//
//  StudioSchedule.swift
//  Model
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation
import Extension
import SwiftExtensions

public struct StudioSchedule {
    
    // start time
    public let startDate: Date
    // return true if this span of time available
    public let available: Bool
    // return true if eaxch studio available
    public typealias StudioAvailables = (studioA: Bool, studioB: Bool, studioC: Bool)
    public let availables: StudioAvailables

    public init(startDate: Date, availables: StudioAvailables) {
        self.startDate = startDate
        self.availables = availables
        self.available = availables.studioA || availables.studioB || availables.studioC
    }
    
    public static func unavailableSchedule(startDate: Date) -> StudioSchedule {
        let availables = StudioAvailables(studioA: false, studioB: false, studioC: false)
        return StudioSchedule(startDate: startDate, availables: availables)
    }
    
    var isOverNow: Bool {
        return self.startDate <= Date()
    }
}

public final class StudioScheduleFactory {
    
    public static let shared = StudioScheduleFactory()
    private init() {}
    
    public static func make(timeTable: StudioTimeTable, groupedReservations: [String: [StudioReservation]]) -> StudioSchedule? {
        
        let today = Date()
        let key = "\(today.year)/\(today.month)/\(today.day)++\(timeTable.rawValue)"
        let reservations = groupedReservations[key]?.map { $0.studioType } ?? []
        let availables = StudioSchedule.StudioAvailables(studioA: !reservations.contains(.studioA),
                                                         studioB: !reservations.contains(.studioB),
                                                         studioC: !reservations.contains(.studioC))
        let startDate = timeTable.today
        let studioSchedule = StudioSchedule(startDate: startDate, availables: availables)
        return studioSchedule.isOverNow ? nil : studioSchedule
    }
    
    private static func isOverNow(studioSchedule: StudioSchedule) -> Bool {
        let now = Date()
        let startDate = studioSchedule.startDate
        return startDate <= now
    }
}

public enum StudioTimeTable: String, CaseIterable {
    case am0000 = "0:0"
    case am0030 = "0:30"
    case am0100 = "1:0"
    case am0130 = "1:30"
    case am0200 = "2:0"
    case am0230 = "2:30"
    case am0300 = "3:0"
    case am0330 = "3:30"
    case am0400 = "4:0"
    case am0430 = "4:30"
    case am0500 = "5:0"
    case am0530 = "5:30"
    case am0600 = "6:0"
    case am0630 = "6:30"
    case am0700 = "7:0"
    case am0730 = "7:30"
    case am0800 = "8:0"
    case am0830 = "8:30"
    case am0900 = "9:0"
    case am0930 = "9:30"
    case am1000 = "10:0"
    case am1030 = "10:30"
    case am1100 = "11:0"
    case am1130 = "11:30"
    case pm0000 = "12:0"
    case pm0030 = "12:30"
    case pm0100 = "13:0"
    case pm0130 = "13:30"
    case pm0200 = "14:0"
    case pm0230 = "14:30"
    case pm0300 = "15:0"
    case pm0330 = "15:30"
    case pm0400 = "16:0"
    case pm0430 = "16:30"
    case pm0500 = "17:0"
    case pm0530 = "17:30"
    case pm0600 = "18:0"
    case pm0630 = "18:30"
    case pm0700 = "19:0"
    case pm0730 = "19:30"
    case pm0800 = "20:0"
    case pm0830 = "20:30"
    case pm0900 = "21:0"
    case pm0930 = "21:30"
    case pm1000 = "22:0"
    case pm1030 = "22:30"
    case pm1100 = "23:0"
    case pm1130 = "23:30"
    
    public var today: Date {
        let today = Date()
        let year = NSString(format: "%04d", today.year)
        let month = NSString(format: "%04d", today.month)
        let day = NSString(format: "%04d", today.day)
        let todayString = "\(year)/\(month)/\(day) \(self.rawValue):00"
        return DateFormatter.from(locale: .current, format: "yyyy/MM/dd HH:mm:ss").date(from: todayString)!
    }
}
