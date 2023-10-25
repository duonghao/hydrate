//
//  WaterContainer.swift
//  Hydrate
//
//  Created by Hao Duong on 25/10/2023.
//

import Foundation

@Observable
class WaterContainer {
    
    static let absoluteMaxCapacity = 8000
    
    enum StandardisedServingSize: Int {
        case sip = 50
        case cup = 250
    }
    
    private(set) var currentCapacity: Int
    var maxCapacity: Int
    var servingSize: Int
    
    init(currentCapacity: Int = 0, maxCapacity: Int, servingSizing: Int = StandardisedServingSize.cup.rawValue) {
        self.currentCapacity = currentCapacity
        self.maxCapacity = maxCapacity
        self.servingSize = servingSizing
    }
    
    var currentCapacityFraction: Double {
        get { Double(currentCapacity) / Double(maxCapacity) }
        set { }
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
