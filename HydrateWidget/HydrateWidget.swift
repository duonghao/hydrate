//
//  HydrateWidget.swift
//  HydrateWidget
//
//  Created by Hao Duong on 31/10/2023.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    @MainActor
    func placeholder(in context: Context) -> WaterContainerEntry {
        WaterContainerEntry(date: Date.now, currentCapacityFraction: 0.5)
    }

    @MainActor 
    func getSnapshot(in context: Context, completion: @escaping (WaterContainerEntry) -> ()) {
        completion(WaterContainerEntry(waterContainer: getTodaysWaterContainer()))
    }

    @MainActor 
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [WaterContainerEntry(waterContainer: getTodaysWaterContainer())], policy: .after(Calendar.current.tomorrowsDate))
        completion(timeline)
    }
    
    @MainActor 
    private func getTodaysWaterContainer() -> WaterContainer? {
        guard let modelContainer = try? ModelContainer(for: WaterContainer.self) else {
            return nil
        }
        
        let descriptor = FetchDescriptor<WaterContainer>(predicate: WaterContainer.todaysWaterContainerPredicate())
        guard let results = try? modelContainer.mainContext.fetch(descriptor) else {
            return nil
        }
       
        return results.first ?? .init(maxCapacity: 2000)
    }
}

struct WaterContainerEntry: TimelineEntry {
    let date: Date
    let currentCapacityFraction: Double
    
    init(date: Date, currentCapacityFraction: Double) {
        self.date = date
        self.currentCapacityFraction = currentCapacityFraction
    }
    
    init(waterContainer: WaterContainer?) {
        self.date = waterContainer?.timeStamp ?? Date.now
        self.currentCapacityFraction = waterContainer?.currentCapacityFraction ?? 0
    }
}

struct HydrateWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        return ZStack {
            WaveView(heightFraction: entry.currentCapacityFraction, strength: 6, frequency: 10)
                .foregroundStyle(.blue.gradient.opacity(0.8))
                .ignoresSafeArea()
            
            Group {
                VStack {
                    Text(entry.date.weekdayWideFormat)
                        .font(.callout.bold())
                        .foregroundStyle(.black.opacity(0.5))
                    Spacer()
                    Text(entry.currentCapacityFraction.percentFormat)
                        .font(.system(size: 64, weight: .heavy))
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(.black.opacity(0.9))
                        .contentTransition(.numericText(value: entry.currentCapacityFraction))
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct HydrateWidget: Widget {
    let kind: String = "HydrateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HydrateWidgetEntryView(entry: entry)
                    .containerBackground(.background, for: .widget)
            } else {
                HydrateWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Daily Water Consumption")
        .description("Keep track of your water consumption")
    }
}

#Preview(as: .systemSmall) {
    HydrateWidget()
} timeline: {
    WaterContainerEntry(date: Date.now, currentCapacityFraction: 0.3)
    WaterContainerEntry(date: Date.now + 1, currentCapacityFraction: 0.5)
}

extension Date {
    
    var weekdayWideFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
}

extension Double {
    
    var percentFormat: String {
        self.formatted(.percent)
    }
    
}
