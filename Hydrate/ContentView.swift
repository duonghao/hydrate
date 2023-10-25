//
//  ContentView.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI



struct ContentView: View {
    
    @State private var waterContainer: WaterContainer = .init(maxCapacity: 2000)
    @State private var showingContainerSheet = false
    
    var body: some View {
        NavigationStack {
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
                            waterContainer.addCapacity()
                        } label: {
                            Label("Drink", systemImage: "drop.fill")
                                .labelStyle(ExpandableButtonLabelStyle())
                        } content: {
                            // Schedule reminders
                            Button {
                                
                            } label: {
                                Label("Schedule", systemImage: "calendar.badge.clock")
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
                    .buttonStyle(MainButtonStyle())
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showingContainerSheet, content: {
            ContainerChangeSheet(waterContainer: waterContainer)
        })
    }
}

#Preview {
    ContentView()
}
