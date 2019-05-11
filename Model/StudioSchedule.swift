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
        self.available = availables.studioA && availables.studioB && availables.studioC
    }
}

public final class StudioScheduleFactory {
    
    public static let shared = StudioScheduleFactory()
    private init() {}
    
    public static func make(timeTable: StudioTimeTable, groupedReservations: [String: [StudioReservation]]) -> StudioSchedule {
        let today = Date()
        let year = NSString(format: "%04d", today.year)
        let month = NSString(format: "%04d", today.month)
        let day = NSString(format: "%04d", today.day)
        let yyyyMMdd = "\(year)/\(month)/\(day)"
        let todayString = "\(yyyyMMdd) \(timeTable.rawValue):00"
        let startDate = DateFormatter.from(locale: .current, format: "yyyy/MM/dd HH:mm:ss").date(from: todayString)!
        typealias Availables = StudioSchedule.StudioAvailables
        // today reservation and matched time table
        let reserved = groupedReservations.keys.contains { $0.contains(timeTable.rawValue) && $0.contains(yyyyMMdd) }
        if reserved {
            let key = "\(yyyyMMdd)++\(timeTable.rawValue)"
            let reservations = groupedReservations[key]!.map { $0.studioType }
            let availables = Availables(studioA: reservations.contains(.studioA),
                                        studioB: reservations.contains(.studioB),
                                        studioC: reservations.contains(.studioC))
            return StudioSchedule(startDate: startDate, availables: availables)
        } else {
            let todayString = "\(year)/\(month)/\(day) \(timeTable.rawValue):00"
            let startDate = DateFormatter.from(locale: .current, format: "yyyy/MM/dd HH:mm:ss").date(from: todayString)!
            let availables = Availables(studioA: true, studioB: true, studioC: true)
            return StudioSchedule(startDate: startDate, availables: availables)
        }
    }
}

public enum StudioTimeTable: String, CaseIterable {
    case am0000 = "00:00"
    case am0030 = "00:30"
    case am0100 = "01:00"
    case am0130 = "01:30"
    case am0200 = "02:00"
    case am0230 = "02:30"
    case am0300 = "03:00"
    case am0330 = "03:30"
    case am0400 = "04:00"
    case am0430 = "04:30"
    case am0500 = "05:00"
    case am0530 = "05:30"
    case am0600 = "06:00"
    case am0630 = "06:30"
    case am0700 = "07:00"
    case am0730 = "07:30"
    case am0800 = "08:00"
    case am0830 = "08:30"
    case am0900 = "09:00"
    case am0930 = "09:30"
    case am1000 = "10:00"
    case am1030 = "10:30"
    case am1100 = "11:00"
    case am1130 = "11:30"
    case pm0000 = "12:00"
    case pm0030 = "12:30"
    case pm0100 = "13:00"
    case pm0130 = "13:30"
    case pm0200 = "14:00"
    case pm0230 = "14:30"
    case pm0300 = "15:00"
    case pm0330 = "15:30"
    case pm0400 = "16:00"
    case pm0430 = "16:30"
    case pm0500 = "17:00"
    case pm0530 = "17:30"
    case pm0600 = "18:00"
    case pm0630 = "18:30"
    case pm0700 = "19:00"
    case pm0730 = "19:30"
    case pm0800 = "20:00"
    case pm0830 = "20:30"
    case pm0900 = "21:00"
    case pm0930 = "21:30"
    case pm1000 = "22:00"
    case pm1030 = "22:30"
    case pm1100 = "23:00"
    case pm1130 = "23:30"
}
