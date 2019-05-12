//
//  StudioTimeTableViewModel.swift
//  studio
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Model
import Extension
import Shared
import Data

final class StudioTimeTableViewModel: Connectable {
    
    fileprivate let selectedStudioSchedule = PublishSubject<StudioSchedule>()
    fileprivate let sectionModel: Observable<[StudioTimeTableSectionModel]>
    fileprivate let reservedStudio: Observable<Void>
    
    let coordinator: StudioTimeTableCoordinator
    private let disposeBag = DisposeBag()
    
    init(coordinator: StudioTimeTableCoordinator) {
        
        self.coordinator = coordinator
        
        self.sectionModel = StudioReservationManager.shared.reservations
            .map { reservations -> [String: [StudioReservation]] in
                Dictionary(grouping: reservations) { $0.start }
            }
            .map { groupedReservations in
                StudioTimeTable.allCases
                    .compactMap { timeTable -> StudioSchedule? in
                        StudioScheduleFactory.make(timeTable: timeTable, groupedReservations: groupedReservations)
                    }
                    .map { studioSchedule -> StudioTimeTableSectionItem in
                        .item(item: studioSchedule)
                    }
            }
            .map { items -> [StudioTimeTableSectionModel] in
                [.section(items: items)]
            }
        
        self.reservedStudio = self.selectedStudioSchedule
            .map { studioSchedule in
                StudioReservation(startDate: studioSchedule.startDate, studioType: .studioC)!
            }
            .flatMap(StudioApi.reservationService.reserve)

        // sync reservations
        StudioReservationManager.shared.refetchTodayReservations()
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}

extension InputSpace where Definer: StudioTimeTableViewModel {
    var selectedStudioSchedule: AnyObserver<StudioSchedule> { return self.definer.selectedStudioSchedule.asObserver() }
}

extension OutputSpace where Definer: StudioTimeTableViewModel {
    var sectionModel: Observable<[StudioTimeTableSectionModel]> { return self.definer.sectionModel }
    var reservedStudio: Observable<Void> { return self.definer.reservedStudio }
}
