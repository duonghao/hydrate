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
                    Button {
                        hydrationFraction += hydrationFractionIncrement
                    } label: {
                        Label("Drink", systemImage: "drop.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .labelStyle(.iconOnly)
                            .padding(16)
                            .background(.blue)
                            .clipShape(.capsule)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
