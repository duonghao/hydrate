//
//  DateScale.swift
//  Hydrate
//
//  Created by Hao Duong on 28/10/2023.
//

import Foundation

enum DateScale: CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly
    case custom
    
    var id: Self {
        return self
    }
    
    var description: String {
        switch self {
        case .daily:
            return "d"
        case .weekly:
            return "w"
        case .monthly:
            return "m"
        case .custom:
            return "c"
        }
    }
    
    func filter(on: Date, date1: Date? = nil, date2: Date? = nil) -> Bool {
        let calendar = Calendar.current
        switch self {
        case .daily:
            return calendar.isDateInToday(on)
        case .weekly:
            return calendar.isDateInThisWeek(on)
        case .monthly:
            return calendar.isDateInThisMonth(on)
        case .custom:
            guard let date1, let date2 else {
                return false
            }
            return on.isBetween(date1: date1, date2: date2)
        }
    }
    
    func startDate(date: Date = Date.now) -> Date {
        let calendar = Calendar.current
        switch self {
        case .daily:
            return calendar.startOfDay(for: Date.now)
        case .weekly:
            return calendar.startOfWeek(for: Date.now)
        case .monthly:
            return calendar.startOfMonth(for: Date.now)
        case .custom:
            return date - 86400
        }
    }
    
    func endDate(date: Date = Date.now) -> Date {
        let calendar = Calendar.current
        switch self {
        case .daily:
            return calendar.endOfDay(for: Date.now)
        case .weekly:
            return calendar.endOfWeek(for: Date.now)
        case .monthly:
            return calendar.endOfMonth(for: Date.now)
        case .custom:
            return date
        }
    }
}
