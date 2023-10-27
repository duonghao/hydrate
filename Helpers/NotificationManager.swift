//
//  NotificationManager.swift
//  Hydrate
//
//  Created by Hao Duong on 27/10/2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func registerForPushNofications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                return
            }
        }
    }
    
    func createPushNotification(title: String, body: String, at: DateComponents, repeats: Bool = false) {
        let content = generate(title: title, body: body)
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: at, repeats: repeats)
        
        // Create the request
        let uuid = UUID()
        let request = UNNotificationRequest(identifier: uuid.uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        schedule(request: request)
    }
    
    private func generate(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        return content
    }
    
    private func schedule(request: UNNotificationRequest) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }

            if settings.alertSetting == .enabled {
                notificationCenter.add(request) { error in
                    if let error = error {
                      return
                    }
                }
            } else {
                // Schedule a notification with a badge and sound.
            }
        }
    }
    
    func removeAllPendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
}
