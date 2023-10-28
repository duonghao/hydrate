//
//  PreviewSampleData.swift
//  Hydrate
//
//  Created by Hao Duong on 28/10/2023.
//

import SwiftUI
import SwiftData

let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: WaterContainer.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        for previewData in WaterContainer.previewData {
            Task { @MainActor in
                container.mainContext.insert(previewData)
            }
        }
        
        return container
    } catch {
        fatalError("Failed to create container: \(error.localizedDescription)")
    }
}()
