//
//  Coordinator.swift
//  Extension
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import UIKit

public protocol Coordinator {
    associatedtype Route
    var viewController: UIViewController? { get set }
    init()
    init(viewController: UIViewController)
    func transition(to route: Route)
}

public extension Coordinator {
    init(viewController: UIViewController) {
        self.init()
        self.viewController = viewController
    }
}
