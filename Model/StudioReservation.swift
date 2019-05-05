//
//  StudioReservation.swift
//  Model
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public struct StudioReservation {
 
    public let name: String?
    public let owner: Bool?
    public let orderId: Int?
    public let startDate: Date
    public let month: Int
    public let day: Int
    public let start: String
    public let end: String
    public let studioType: StudioType

    public init?(startDate: Date, studioType: StudioType, name: String? = nil, owner: Bool? = nil, orderId: Int? = nil) {
        
        // 利用可能時間かどうか確認
        guard studioType.available(in: startDate) else { return nil }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute else { return nil }
     
        self.startDate = startDate
        self.month = month
        self.day = day
        self.start = "\(year)/\(month)/\(day)++\(hour):\(minute)"
        self.end = "\(year)/\(month)/\(day)++\(hour + 1):\(minute)"
        self.studioType = studioType
        
        // optionals
        self.name = name
        self.owner = owner
        self.orderId = orderId
    }
}

public extension StudioReservation {
    enum StudioType: Int {
        case studioA = 200625
        case studioB = 200626
        case studioC = 200627
    }
}

extension StudioReservation.StudioType {
    func available(in time: Date) -> Bool {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
        guard let hour = components.hour,
              let minute = components.minute,
              let second = components.second, second == 0 else { return false }
        switch self {
        case .studioA:
            return minute == 0 || minute == 30
        case .studioB, .studioC:
            // 6時から23時の 23時30分 以外
            if hour == 23 && minute == 30 { return false }
            return (6 <= hour && hour <= 23) && (minute == 0 || minute == 30)
        }
    }
}

public final class StudioReservationFactory {
    
    public static let shared = StudioReservationFactory()
    private init() {}
    
    public func parse(responseStrings: [String]) -> [StudioReservation] {
        return responseStrings
            .map { string -> String in
                let string = string
                    .replacingOccurrences(of: "var app=[", with: "")
                    .replacingOccurrences(of: " ", with: "")
                let valueString = string.replacingOccurrences(of: "]$",
                                                              with: "",
                                                              options: .regularExpression,
                                                              range: string.range(of: string))
                return valueString.replacingOccurrences(of: "],",
                                                        with: "]\n",
                                                        options: .regularExpression,
                                                        range: valueString.range(of: valueString))
            }
            .map { $0.split(separator: "\n") }
            .flatMap { $0 }
            .map {
                return $0
                    .replacingOccurrences(of: "[", with: "")
                    .replacingOccurrences(of: "]", with: "")
                    .split(separator: ",")
                    .map(String.init)
            }
            .map { info -> StudioReservation in
                let timeInterval = TimeInterval(Int(info.first!)! - 3600*9)
                let date = Date(timeIntervalSince1970: timeInterval)
                let studioType = StudioReservation.StudioType(rawValue: Int(info[2])!)!
                return StudioReservation(startDate: date, studioType: studioType, name: info[8], owner: info[7] == "true", orderId: Int(info[3])!)!
            }
            //.filter { $0 != nil }
    }
}
