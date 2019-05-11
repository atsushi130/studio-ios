//
//  StudioTimeTableConfigurator.swift
//  studio
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation
import Extension

struct StudioTimeTableConfigurator: Configurator {
    typealias VC = StudioTimeTableViewController
    static func configure(with vc: VC, dependency: VC.Dependency) {
        let coordinator = StudioTimeTableCoordinator(viewController: vc)
        let viewModel = StudioTimeTableViewModel(coordinator: coordinator)
        vc.inject(viewModel)
    }
}
