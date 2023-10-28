//
//  HistorySheet.swift
//  Hydrate
//
//  Created by Hao Duong on 27/10/2023.
//

import SwiftUI
import Charts

struct Consumption: Identifiable {
    var id = UUID()
    var date: Date
    var total: Int
}

struct HistorySheet: View {
    
    enum Range: String, CaseIterable, Identifiable {
        
        var id: Self {
            return self
        }
        case daily = "d"
        case weekly = "w"
        case month = "m"
    }
    
    @Environment(\.dismiss) private var dismiss
    private let title: String = "History"
    private let data: [Consumption] = [
        .init(date: Date.now, total: 2000),
        .init(date: Date.now + 86400, total: 1500),
        .init(date: Date.now + 2 * 86400, total: 1800),
        .init(date: Date.now + 3 * 86400, total: 2000),
        .init(date: Date.now + 4 * 86400, total: 2300),
        .init(date: Date.now + 5 * 86400, total: 1750),
        .init(date: Date.now + 6 * 86400, total: 1500),
    ]
    @State private var selection: String = "d"
    
    var body: some View {
        NavigationStack {
            VStack {
                rangePicker
                    .padding(.bottom)
                
                chart
            }
            .padding()
            .modifier(SheetToolbarViewModifier(title: title, dismiss: dismiss))
        }
    }
    
    private var rangePicker: some View {
        Picker("Range", selection: $selection) {
            ForEach(Range.allCases) { range in
                Text(range.rawValue.capitalized).tag(range.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var chart: some View {
        Chart {
            ForEach(data) { dataPoint in
                BarMark(
                    x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Total", dataPoint.total)
                )
                .cornerRadius(8)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [
                    .blue.opacity(0.8),
                    .blue.opacity(0.5),
                    .blue.opacity(0.1),
                ]), startPoint: .top, endPoint: .bottom))
                RuleMark(y: .value("Daily Target", 2000))
                    .lineStyle(.init(dash: [1]))
                    .foregroundStyle(.red.opacity(0.8))
            }
            
        }
    }
}

#Preview {
    HistorySheet()
}
