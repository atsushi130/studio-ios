//
//  Date+.swift
//  Extension
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public extension Date {
    
    var year: Int {
        return self.extractComponent(.year)
    }
    
    var month: Int {
        return self.extractComponent(.month)
    }
    
    var day: Int {
        return self.extractComponent(.day)
    }
    
    var hour: Int {
        return self.extractComponent(.hour)
    }
    
    var minute: Int {
        return self.extractComponent(.minute)
    }
    
    var second: Int {
        return self.extractComponent(.second)
    }
    
    private func extractComponent(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
}
