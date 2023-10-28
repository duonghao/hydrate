//
//  HydrateApp.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI
import SwiftData

@main
struct HydrateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WaterContainer.self)
    }
}
