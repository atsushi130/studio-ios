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

extension StudioTimeTableViewController: RoutableViewController {
    typealias ViewControllerConfigurator = StudioTimeTableConfigurator
    typealias Dependency = Void
}

final class StudioTimeTableViewController: UIViewController, ViewModelInjectable {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    private typealias DataSource = RxCollectionViewSectionedReloadDataSource<StudioTimeTableSectionModel>
    private lazy var dataSource = DataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, _) in
        let item = dataSource[indexPath]
        switch item {
        case let .item(studioSchedule):
            print("----------")
            print("start: \(studioSchedule.startDate)")
            let availables = studioSchedule.availables
            print("A: \(availables.studioA) B: \(availables.studioA) C: \(availables.studioA)")
            return UICollectionViewCell()
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
