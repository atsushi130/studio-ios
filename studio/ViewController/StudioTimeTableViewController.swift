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

extension StudioTimeTableViewController: RoutableViewController {
    typealias ViewControllerConfigurator = StudioTimeTableConfigurator
    typealias Dependency = Void
}

final class StudioTimeTableViewController: UIViewController, ViewModelInjectable {
 
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(cellType: StudioTimeTableCell.self)
        }
    }
    
    private typealias DataSource = RxCollectionViewSectionedReloadDataSource<StudioTimeTableSectionModel>
    private lazy var dataSource = DataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, _) in
        guard let `self` = self else { return UICollectionViewCell() }
        let item = dataSource[indexPath]
        switch item {
        case let .item(studioSchedule):
            let availables = studioSchedule.availables
            let cell = self.collectionView.dequeueReusableCell(with: StudioTimeTableCell.self, for: indexPath)
            cell.startTimeLabel.text = "\(studioSchedule.startDate)"
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
            .bind(to: self.viewModel.in.selectedStudioSchedule)
            .disposed(by: self.disposeBag)
    }
}
