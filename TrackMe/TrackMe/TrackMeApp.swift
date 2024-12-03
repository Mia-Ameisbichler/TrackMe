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
    
    let exampleHabit = Habit(
        name: "Morning Yoga",
        info: "15-minute daily yoga session to improve flexibility and focus.",
        time: Date(),
        regularity: [true, true, true, true, true, false, false], // Mon-Fri active
        notification: true,
        duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!,
        streak: 5
    )
    
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
    
    private func handleNotification(_ notification: UNNotification) {
        print("Notification received: \(notification.request.content.title)")

        if let habitData = notification.request.content.userInfo["habit"] as? Data {
            let decoder = JSONDecoder()
            if let habit = try? decoder.decode(Habit.self, from: habitData) {
                print("Decoded habit: \(habit.name)")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .openHabitDetail, object: habit)
                }
            } else {
                print("Failed to decode habit data.")
            }
        } else {
            print("No habit data found in userInfo.")
        }
    }
    
    // This method is called when a notification is delivered to the app while it's in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification while the app is in the foreground
        handleNotification(notification)

        // Optionally show the notification banner
        completionHandler([.banner, .badge, .sound])
    }
    
    // Optional: Handle when the user interacts with the notification (e.g., taps it)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification when the user taps it
        handleNotification(response.notification)

        completionHandler()
    }
}
