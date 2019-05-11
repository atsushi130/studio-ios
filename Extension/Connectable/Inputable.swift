//
//  Inputable.swift
//  Extension
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public struct InputSpace<Definer> {
    public let definer: Definer
    init(_ definer: Definer) {
        self.definer = definer
    }
}

public protocol Inputable {
    static var `in`: InputSpace<Self>.Type { get }
    var `in`: InputSpace<Self> { get }
}

extension Inputable {
    
    public static var `in`: InputSpace<Self>.Type {
        return InputSpace<Self>.self
    }
    
    public var `in`: InputSpace<Self> {
        return InputSpace(self)
    }
}
