//
//  TrackMeApp.swift
//  TrackMe
//
//  Created by Mia Ameisbichler on 08.11.24.
//

import SwiftUI

@main
struct TrackMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            HabitListView()
        }.modelContainer(for: [Habit.self])
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied: \(String(describing: error))")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        
        // Set the notification delegate to this class
        UNUserNotificationCenter.current().delegate = self
    }
    
    // This method is called when a notification is delivered to the app while it's in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show the notification even when the app is open (foreground)
        completionHandler([.banner, .badge, .sound])
    }
    
    // Optional: Handle when the user interacts with the notification (e.g., taps it)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User interacted with the notification: \(response.notification.request.identifier)")
        completionHandler()
    }
}
