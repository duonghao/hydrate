//
//  ContentView.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI



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
    
    @State private var waterContainer: WaterContainer = .init(maxCapacity: 2000)
    @State private var statusIndicatorType: StatusIndicatorType = .percentConsumed
    @State private var showingHistorySheet = false
    @State private var showingContainerSheet = false
    @State private var showingNotificationSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                WaveView(heightFraction: $waterContainer.currentCapacityFraction, fillColor: .blue)
                    .ignoresSafeArea()
                statusIndicator
                navMenu
            }
        }
        .sheet(isPresented: $showingHistorySheet, content: {
            HistorySheet()
        })
        .sheet(isPresented: $showingContainerSheet, content: {
            ContainerChangeSheet(waterContainer: waterContainer)
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
                        Text(waterContainer.currentCapacityFraction.formatted(.percent))
                    }
                case .totalConsumed:
                    VStack {
                        Text("Consumed")
                            .font(.caption)
                        Text("\(waterContainer.currentCapacity.formatted(.number)) mL")
                    }
                case .percentRemaining:
                    VStack {
                        Text("Remaining")
                            .font(.caption)
                        Text(waterContainer.remainingCapacityFraction.formatted(.percent))
                    }
                case .totalRemaining:
                    VStack {
                        Text("Remaining")
                            .font(.caption)
                        Text("\(waterContainer.remainingCapacity.formatted(.number)) mL")
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
            waterContainer.reset()
        } label: {
            Label("Rest", systemImage: "xmark")
                .labelStyle(ExpandableButtonLabelStyle())
        }
    }
    
    private var navMenuButtons: some View {
        ExpandableButton {
            waterContainer.addCapacity()
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
}
