//
//  StudioReservationManager.swift
//  Shared
//
//  Created by Atsushi Miyake on 2019/05/06.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation
import RxSwift
import Model
import Data

public final class StudioReservationManager {
    
    public static let shared = StudioReservationManager()
    
    private let _reservations = PublishSubject<[StudioReservation]>()
    public let myReservations: Observable<[StudioReservation]>
    public let reservations: Observable<[StudioReservation]>
    
    private init() {
        self.reservations = self._reservations.asObservable()
        self.myReservations = self.reservations
            .map { reservations in
                reservations.filter { $0.owner == true }
            }
    }
    
    @discardableResult
    public func refetchReservations(month: Int, day: Int) -> Observable<[StudioReservation]> {
        return StudioApi.reservationService
            .fetchReservations(month: month, day: day)
            .do(onNext: self._reservations.onNext)
    }
}
