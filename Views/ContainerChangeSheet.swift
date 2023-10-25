//
//  ServingSizeChangeSheet.swift
//  Hydrate
//
//  Created by Hao Duong on 25/10/2023.
//

import SwiftUI

struct ContainerChangeSheet: View {
    
    @Bindable var waterContainer: WaterContainer
    @State private var isCustom: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                containerSection
                servingSection
            }
        }
    }
    
    private var containerSection: some View {
        Section {
            containerPicker
                .disabled(isCustom)
            
            Toggle(isOn: $isCustom) {
                Text("Custom")
            }
            
            if isCustom {
                customSizePicker(size: $waterContainer.maxCapacity, from: 0, to: WaterContainer.absoluteMaxCapacity)
            }
        } header: {
            Text("Container")
        }
    }
    
    private var containerPicker: some View {
        Picker("Sizes", selection: $waterContainer.maxCapacity) {
            ForEach(Array(stride(from: 0, to: WaterContainer.absoluteMaxCapacity, by: 1000)), id: \.self) { size in
                Text("\(size) mL")
            }
        }
    }
    
    private var servingSection: some View {
        Section {
            servingPicker
                .disabled(isCustom)
            
            Toggle(isOn: $isCustom) {
                Text("Custom")
            }
            
            if isCustom {
                customSizePicker(size: $waterContainer.servingSize, from: 0, to: waterContainer.maxCapacity)
            }
        } header: {
            Text("Serving")
        }
    }
    
    private var servingPicker: some View {
        Picker("Sizes", selection: $waterContainer.servingSize) {
            Text("Sip (~ 50mL)").tag(50)
            Text("Cup (~ 250mL)").tag(250)
            Text("Bottle (~ 500mL)").tag(500)
        }
    }
    
    @ViewBuilder
    private func customSizePicker(size: Binding<Int>, from: Int, to: Int) -> some View {
        Slider(value: IntDoubleBinding(size).doubleValue, in: Double(from)...Double(to), step: 1)
        HStack {
            Spacer()
            Text("\(size.wrappedValue) mL")
        }
    }
}

#Preview {
    ContainerChangeSheet(waterContainer: .init(maxCapacity: 2000))
}
