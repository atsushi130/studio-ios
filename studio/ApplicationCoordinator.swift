//
//  ApplicationCoordinator.swift
//  studio
//
//  Created by Atsushi Miyake on 2019/05/12.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import UIKit
import Extension

struct ApplicationCoordinator: Coordinator {
    
    weak var viewController: UIViewController? = nil
    private let window: UIWindow?
    
    init() {
        self.viewController = nil
        self.window = nil
    }

    init(window: UIWindow?) {
        self.window = window
    }
    
    enum Route {
        case studioTimeTable
    }
    
    func transition(to route: Route) {
        switch route {
        case .studioTimeTable:
            let vc = StudioTimeTableViewController.instantiate()
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = vc
        }
    }
}
