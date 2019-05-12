//
//  StudioTimeTableViewController.swift
//  studio
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftExtensions
import Model
import Extension
import ViewComponent
import Shared

extension StudioTimeTableViewController: RoutableViewController {
    typealias ViewControllerConfigurator = StudioTimeTableConfigurator
    typealias Dependency = Void
}

final class StudioTimeTableViewController: UIViewController, ViewModelInjectable {
 
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.collectionViewLayout = self.layout
            self.collectionView.register(cellType: StudioTimeTableCell.self)
        }
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // self sizing by autolayout
        layout.estimatedItemSize = CGSize(width: 375, height: 100)
        return layout
    }()
    
    private typealias DataSource = RxCollectionViewSectionedReloadDataSource<StudioTimeTableSectionModel>
    private lazy var dataSource = DataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, _) in
        guard let `self` = self else { return UICollectionViewCell() }
        let item = dataSource[indexPath]
        switch item {
        case let .item(studioSchedule):
            let cell = self.collectionView.dequeueReusableCell(with: StudioTimeTableCell.self, for: indexPath)
            cell.studioSchedule = studioSchedule
            return cell
        }
    })
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: StudioTimeTableViewModel!
    typealias ViewModel = StudioTimeTableViewModel
    func inject(_ viewModel: StudioTimeTableViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.rx.setDataSource(self.dataSource)
            .disposed(by: self.disposeBag)
        
        self.viewModel.out.sectionModel
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(StudioTimeTableSectionItem.self)
            .map { $0.item }
            .flatMap { item -> Observable<StudioSchedule> in
                let result = PublishSubject<StudioSchedule>()
                let hour =  NSString(format: "%02d", item.startDate.hour)
                let minute = NSString(format: "%02d", item.startDate.minute)
                let alert = UIAlertController(title: "スタジオ予約", message: "\(hour):\(minute)からスタジオを予約しますか？", preferredStyle: .alert)
                let reserve = UIAlertAction(title: "予約する", style: .default) { _ in
                    result.onNext(item)
                }
                let cancel = UIAlertAction(title: "しない", style: .cancel)
                alert.addAction(reserve)
                alert.addAction(cancel)
                self.present(alert, animated: true)
                return result
            }
            .bind(to: self.viewModel.in.selectedStudioSchedule)
            .disposed(by: self.disposeBag)
        
        self.viewModel.out.reservedStudio
            .do(onNext: { _ in
                let alert = UIAlertController.okAlertController(title: "予約が完了しました！")
                self.present(alert, animated: true)
            })
            .flatMap { StudioReservationManager.shared.refetchTodayReservations() }
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
