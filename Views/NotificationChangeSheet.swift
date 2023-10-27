//
//  ScheduleChangeSheet.swift
//  Hydrate
//
//  Created by Hao Duong on 26/10/2023.
//

import SwiftUI
import DebouncedOnChange

struct NotificationChangeSheet: View {
    
    typealias Label = String
    typealias Selection = String
    
    @AppStorage("isUserNotificationsEnabled") var isUserNotificationsEnabled: Bool = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("notificationStartTime") private var startTime: Date = Calendar.current.date(from: DateComponents(hour: 9))!
    @AppStorage("notificationEndTime") private var endTime: Date = Calendar.current.date(from: DateComponents(hour: 17))!
    @AppStorage("notificationTimeIntervalSelection") private var timeIntervalSelection: [Selection] = [0, 1].map { "\($0)" }
    private let timeIntervals: [(Label, [Selection])] = [
        ("hours", Array(0...23).map { "\($0)" }),
        ("min", Array(0...59).map { "\($0)" })
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    userNotificationToggle
                    if isUserNotificationsEnabled {
                        userNotificationSettings
                    }
                }
            }
            .modifier(SheetToolbarViewModifier(title: "Notifications", dismiss: dismiss))
        }
    }
    
    private var userNotificationToggle: some View {
        Toggle("Allow Notifications", isOn:$isUserNotificationsEnabled)
            .onChange(of: isUserNotificationsEnabled) { _, notificationsEnabled in
                if notificationsEnabled {
                    NotificationManager.shared.registerForPushNofications()
                }
            }
    }
    
    @ViewBuilder
    private var userNotificationSettings: some View {
        DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
            .onChange(of: startTime, debounceTime: .seconds(2)) { _ in
                scheduleNotifications()
            }
        DatePicker("End Time", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
            .onChange(of: endTime, debounceTime: .seconds(2)) { _ in
                scheduleNotifications()
            }
        VStack(alignment: .leading) {
            Text("Interval")
                .padding([.top], 8)
            MultiPicker(data: timeIntervals, selection: $timeIntervalSelection, showLabel: true)
                .frame(minHeight: 200)
                .onChange(of: timeIntervalSelection, debounceTime: .seconds(2)) { _ in
                    scheduleNotifications()
                }
        }
    }
    
    private func scheduleNotifications() -> Void {
        NotificationManager.shared.removeAllPendingNotifications()
        
        var interval = DateComponents()
        interval.hour = Int(timeIntervalSelection[0])
        interval.minute = Int(timeIntervalSelection[1])
        
        for scheduledDate in (dates(from: startTime, to: endTime, interval: interval)) {
            let scheduledDateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduledDate)
            NotificationManager.shared.createPushNotification(title: "Hydrate", body: "Hydration is key", at: scheduledDateComponents, repeats: false)
        }
    }
}

#Preview {
    NotificationChangeSheet()
}
