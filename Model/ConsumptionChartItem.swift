//
//  ConsumptionChartItem.swift
//  Hydrate
//
//  Created by Hao Duong on 28/10/2023.
//

import Foundation

struct Consumption: Identifiable {
    var id = UUID()
    var date: Date
    var total: Int
}
