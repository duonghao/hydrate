//
//  ContentView.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI

@Observable
class WaterContainer {
    
    private(set) var currentCapacity: Double
    let maxCapacity: Double
    
    init(currentCapacity: Double = 0.0, maxCapacity: Double) {
        self.currentCapacity = currentCapacity
        self.maxCapacity = maxCapacity
    }
    
    var currentCapacityFraction: Double {
        get { currentCapacity / maxCapacity }
        set { }
    }
    
    func addCapacity(_ serving: ServingSize) {
        currentCapacity += serving.rawValue
    }
    
    func addCapacity(_ quantity: Double) {
        currentCapacity += quantity
    }
    
    func reset() {
        currentCapacity = 0.0
    }

}

enum ServingSize: Double {
    case cup = 250
}

struct ContentView: View {
    
    @State private var waterContainer: WaterContainer = .init(maxCapacity: 2000)
    @State private var servingSize: ServingSize = .cup
    
    var body: some View {
        ZStack {
            WaveView(heightFraction: $waterContainer.currentCapacityFraction, fillColor: .blue)
                .ignoresSafeArea()
            Text(waterContainer.currentCapacityFraction.formatted(.percent))
                .font(.largeTitle.bold())
            VStack {
                Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    .padding(.vertical)
                    .font(.callout)
                Spacer()
                HStack(alignment: .bottom) {
                    Button {
                        waterContainer.reset()
                    } label: {
                        Label("Rest", systemImage: "xmark")
                            .labelStyle(ExpandableButtonLabelStyle())
                    }
                    Spacer()
                    ExpandableButton {
                        waterContainer.addCapacity(.cup)
                    } label: {
                        Label("Drink", systemImage: "drop.fill")
                            .labelStyle(ExpandableButtonLabelStyle())
                    } content: {
                        // Schedule reminders
                        Button {
                        
                        } label: {
                            Label("Container", systemImage: "calendar.badge.clock")
                                .labelStyle(ExpandableButtonLabelStyle())
                        }
                        
                        // Select daily consumption and container size
                        Button {
                            
                        } label: {
                            Label("Container", systemImage: "waterbottle.fill")
                                .labelStyle(ExpandableButtonLabelStyle())
                        }
                    }
                }
                .buttonStyle(MainButtonStyle())
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
