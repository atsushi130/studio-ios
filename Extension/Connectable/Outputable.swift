//
//  Outputable.swift
//  Extension
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public struct OutputSpace<Definer> {
    public let definer: Definer
    init(_ definer: Definer) {
        self.definer = definer
    }
}

public protocol Outputable {
    static var out: OutputSpace<Self>.Type { get }
    var out: OutputSpace<Self> { get }
}

extension Outputable {
    
    public static var out: OutputSpace<Self>.Type {
        return OutputSpace<Self>.self
    }
    
    public var out: OutputSpace<Self> {
        return OutputSpace(self)
    }
}
