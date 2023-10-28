//
//  WaterContainer.swift
//  Hydrate
//
//  Created by Hao Duong on 25/10/2023.
//

import Foundation
import SwiftData

@Model
final class WaterContainer {
    
    static var previewData: [WaterContainer] = [
        .init(timeStamp: Date.now - 3 * 86400, currentCapacity: 800, maxCapacity: 2000),
        .init(timeStamp: Date.now - 2 * 86400, currentCapacity: 800, maxCapacity: 2000),
        .init(timeStamp: Date.now - 86400, currentCapacity: 800, maxCapacity: 2000),
        .init(timeStamp: Date.now, currentCapacity: 800, maxCapacity: 2000),
        .init(timeStamp: Date.now + 2 * 86400, currentCapacity: 1200, maxCapacity: 2000),
        .init(timeStamp: Date.now + 3 * 86400, currentCapacity: 600, maxCapacity: 2000),
        .init(timeStamp: Date.now + 4 * 86400, currentCapacity: 2000, maxCapacity: 2000),
        .init(timeStamp: Date.now + 5 * 86400, currentCapacity: 1500, maxCapacity: 2000),
        .init(timeStamp: Date.now + 6 * 86400, currentCapacity: 1500, maxCapacity: 2000),
        .init(timeStamp: Date.now + 7 * 86400, currentCapacity: 1500, maxCapacity: 2000),
        .init(timeStamp: Date.now + 8 * 86400, currentCapacity: 1500, maxCapacity: 2000)
    ]
    
    static let absoluteMaxCapacity = 8000
    
    enum StandardisedServingSize: Int {
        case sip = 50
        case cup = 250
    }
    
    private(set) var currentCapacity: Int
    var timeStamp: Date
    var maxCapacity: Int
    var servingSize: Int
    
    init(timeStamp: Date = Date.now, currentCapacity: Int = 0, maxCapacity: Int, servingSizing: Int = StandardisedServingSize.cup.rawValue) {
        self.timeStamp = timeStamp
        self.currentCapacity = currentCapacity
        self.maxCapacity = maxCapacity
        self.servingSize = servingSizing
    }
    
    var currentCapacityFraction: Double {
        get { Double(currentCapacity) / Double(maxCapacity) }
        set { }
    }
    
    var remainingCapacityFraction: Double {
        get { Double(remainingCapacity) / Double(maxCapacity) }
        set { }
    }

    var remainingCapacity: Double {
        Double(maxCapacity - currentCapacity)
    }
    
    func addCapacity() {
        currentCapacity += servingSize
    }
    
    func addCapacity(_ quantity: Int) {
        currentCapacity += quantity
    }
    
    func reset() {
        currentCapacity = 0
    }
    
    func setServingSize(standardisedServingSize: StandardisedServingSize) {
        self.servingSize = standardisedServingSize.rawValue
    }
    
    func setServingSize(_ servingSize: Int) {
        self.servingSize = servingSize
    }

}

