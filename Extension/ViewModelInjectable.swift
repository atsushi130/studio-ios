//
//  ViewModelInjectable.swift
//  Extension
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public protocol ViewModelInjectable {
    associatedtype ViewModel
    func inject(_ viewModel: ViewModel)
}

public extension ViewModelInjectable where ViewModel == Void {
    func inject(_ viewModel: ()) {}
}
