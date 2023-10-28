//
//  ContentView.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    enum StatusIndicatorType: Int, CaseIterable {
        case percentConsumed
        case totalConsumed
        case percentRemaining
        case totalRemaining
        
        mutating func goNext() -> Void {
            if (self.rawValue == StatusIndicatorType.allCases.count - 1) {
                self = Self(rawValue: 0)!
            } else {
                self = Self(rawValue: self.rawValue + 1)!
            }
        }
    }
    
    @Environment(\.modelContext) private var modelContext
    @Query private var waterContainers: [WaterContainer]
    var currentWaterContainer: WaterContainer {
        get {
            let calendar = Calendar.current
            let currentContainer = waterContainers.filter({ calendar.isDateInToday($0.timeStamp) }).first
            
            if let currentContainer = currentContainer {
                return currentContainer
            } else {
                let newWaterContainer = WaterContainer(maxCapacity: 2000)
                modelContext.insert(newWaterContainer)
                return newWaterContainer
            }
        }
    }

    @State private var statusIndicatorType: StatusIndicatorType = .percentConsumed
    @State private var showingHistorySheet = false
    @State private var showingContainerSheet = false
    @State private var showingNotificationSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                WaveView(heightFraction: currentWaterContainer.currentCapacityFraction, fillColor: .blue)
                    .ignoresSafeArea()
                statusIndicator
                navMenu
            }
        }
        .sheet(isPresented: $showingHistorySheet, content: {
            HistorySheet()
        })
        .sheet(isPresented: $showingContainerSheet, content: {
            ContainerChangeSheet(waterContainer: currentWaterContainer)
        })
        .sheet(isPresented: $showingNotificationSheet, content: {
            NotificationChangeSheet()
        })
    }
    
    @ViewBuilder
    private var statusIndicator: some View {
        VStack {
            Text("Consumed")
                .font(.caption)
            Text("99999%")
        }
        .hidden()
        .font(.largeTitle.bold())
        .padding()
        .padding(.horizontal)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
        .overlay {
            Group {
                switch(statusIndicatorType) {
                case .percentConsumed:
                    VStack {
                        Text("Consumed")
                            .font(.caption)
                        Text(currentWaterContainer.currentCapacityFraction.formatted(.percent))
                    }
                case .totalConsumed:
                    VStack {
                        Text("Consumed")
                            .font(.caption)
                        Text("\(currentWaterContainer.currentCapacity.formatted(.number)) mL")
                    }
                case .percentRemaining:
                    VStack {
                        Text("Remaining")
                            .font(.caption)
                        Text(currentWaterContainer.remainingCapacityFraction.formatted(.percent))
                    }
                case .totalRemaining:
                    VStack {
                        Text("Remaining")
                            .font(.caption)
                        Text("\(currentWaterContainer.remainingCapacity.formatted(.number)) mL")
                    }
                }
            }
            .font(.largeTitle.bold())
            .onTapGesture {
                withAnimation() {
                    statusIndicatorType.goNext()
                }
            }
        }
    }
    
    private func indicator(title: String, value: Decimal, format: Decimal.FormatStyle, unit: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
            Text("\(value.formatted(format)) \(unit)")
        }
    }
    
    private var navMenu: some View {
        VStack {
            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                .padding(.vertical)
                .font(.callout)
            Spacer()
            HStack(alignment: .bottom) {
                resetButton
                Spacer()
                navMenuButtons
            }
            .buttonStyle(MainButtonStyle())
            .padding(.horizontal)
        }
    }
    
    private var resetButton: some View {
        Button {
            currentWaterContainer.reset()
        } label: {
            Label("Rest", systemImage: "xmark")
                .labelStyle(ExpandableButtonLabelStyle())
        }
    }
    
    private var navMenuButtons: some View {
        ExpandableButton {
            currentWaterContainer.addCapacity()
        } label: {
            Label("Drink", systemImage: "drop.fill")
                .labelStyle(ExpandableButtonLabelStyle())
        } content: {
            // Show history
            Button {
                showingHistorySheet = true
            } label: {
                Label("History", systemImage: "chart.bar.fill")
                    .labelStyle(ExpandableButtonLabelStyle())
            }
            
            // Schedule notifications
            Button {
                showingNotificationSheet = true
            } label: {
                Label("Notifications", systemImage: "calendar.badge.clock")
                    .labelStyle(ExpandableButtonLabelStyle())
            }
            
            // Select daily consumption and container size
            Button {
                showingContainerSheet = true
            } label: {
                Label("Container", systemImage: "waterbottle.fill")
                    .labelStyle(ExpandableButtonLabelStyle())
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
