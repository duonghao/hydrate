//
//  Calendar-Exts.swift
//  Hydrate
//
//  Created by Hao Duong on 28/10/2023.
//

import SwiftUI

extension Calendar {
    private var currentDate: Date { return Date() }
    
    func isDateInThisWeek(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
    
    func isDateInThisMonth(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    func endOfDay(for weekDate: Date) -> Date {
        return date(byAdding: .day, value: 1, to: startOfDay(for: weekDate))!
    }
    
    func startOfWeek(for weekDate: Date) -> Date {
        return dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: weekDate).date!
    }
    
    func endOfWeek(for weekDate: Date) -> Date {
        return date(byAdding: .day, value: 7, to: startOfWeek(for: weekDate))!
    }
    
    func startOfMonth(for weekDate: Date) -> Date {
        return dateComponents([.calendar, .year, .month], from: weekDate).date!
    }
    
    func endOfMonth(for weekDate: Date) -> Date {
        return date(byAdding: .month, value: 1, to: startOfMonth(for: weekDate))!
    }
    
}

extension Date {
    func isBetween(date1: Date, date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
