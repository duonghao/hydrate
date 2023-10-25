//
//  ContentView.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var hydrationFraction: Double = 0.0
    private var hydrationFractionIncrement: Double = 0.1
    
    var body: some View {
        ZStack {
            WaveView(heightFraction: $hydrationFraction, fillColor: .blue)
                .ignoresSafeArea()
            Text(hydrationFraction.formatted(.percent))
                .font(.largeTitle.bold())
            VStack {
                Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    .padding(.vertical)
                    .font(.callout)
                Spacer()
                HStack {
                    Spacer()
                    ExpandableButton {
                        hydrationFraction += hydrationFractionIncrement
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
                    .frame(maxWidth: 54)
                    .font(.title2)
                    .background(.thickMaterial)
                    .clipShape(.capsule)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
