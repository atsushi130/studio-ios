//
//  StudioSchedule.swift
//  Model
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public struct StudioSchedule {
    
    // start time
    public let startDate: Date
    // return true if this span of time available
    public let available: Bool
    // return true if eaxch studio available
    public typealias StudioAvailables = (studioA: Bool, studioB: Bool, studioC: Bool)
    public let availables: StudioAvailables

    init(startDate: Date, availables: StudioAvailables) {
        self.startDate = startDate
        self.availables = availables
        self.available = availables.studioA && availables.studioB && availables.studioC
    }
}
