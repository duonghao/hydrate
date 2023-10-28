//
//  HistorySheet.swift
//  Hydrate
//
//  Created by Hao Duong on 27/10/2023.
//

import Charts
import SwiftData
import SwiftUI

struct HistorySheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Query private var waterContainers: [WaterContainer]
    @State private var dateScale: DateScale = .weekly
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    private let title: String = "History"
    private var filteredData: [Consumption] {
        return waterContainers.filter( { dateScale.filter(on: $0.timeStamp, date1: startDate, date2: endDate) }).map({ Consumption(date: $0.timeStamp, total: $0.currentCapacity)})
    }
    
    var body: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                chart
                
                rangePicker
                
                if (dateScale == .custom) {
                    HStack {
                        DatePicker(
                            "Start Date",
                            selection: $startDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        Spacer()
                        Label("", systemImage: "arrow.right")
                        Spacer()
                        DatePicker(
                            "End Date",
                            selection: $endDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .fixedSize()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .modifier(SheetToolbarViewModifier(title: title, dismiss: dismiss))
        }
    }
    
    private var rangePicker: some View {
        Picker("Date Scale", selection: $dateScale.animation()) {
            ForEach(DateScale.allCases) { option in
                Text(option.description.capitalized)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var chart: some View {
        Chart(filteredData) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Total", $0.total)
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
        .chartXScale(domain: [dateScale.startDate(date: startDate), dateScale.endDate(date: endDate)])
        .chartYScale(domain: [0, 4000])
    }
}

#Preview {
    HistorySheet()
        .modelContainer(previewContainer)
}
