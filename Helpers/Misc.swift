//
//  Misc.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import Foundation
import SwiftUI

struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}

func dates(from start: Date,
           to end: Date,
           interval: DateComponents) -> [Date] {
    var result = [Date]()
    var working = start
    repeat {
        result.append(working)
        guard let new = Calendar.current.date(byAdding: interval, to: working) else { return result }
        working = new
    } while working <= end
    return result
}
