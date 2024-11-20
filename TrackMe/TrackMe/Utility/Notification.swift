import SwiftUI
import UserNotifications

struct Notification {
    // Daily Notification
    func scheduleDailyNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "This notification will show up every day at 8:00 AM."
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily notification: \(error.localizedDescription)")
            } else {
                print("Daily Notification scheduled for \(hour):\(minute).")
            }
        }
    }
    
    // Multiple Notifications per Day
    func scheduleMultipleNotifications(hours: [Int], minutes: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = "Multiple Notifications"
        content.body = "This notification appears multiple times during the day."
        content.sound = .default
        
        let calendar = Calendar.current
        
        for (index, hour) in hours.enumerated() {
            let minute = minutes[index]
            
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            dateComponents.hour = hour
            dateComponents.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(hour):\(minute).")
                }
            }
        }
    }
    
    // Weekly Notification on Specific Days
    func scheduleWeeklyNotificationOnSpecificDays(hours: [Int], minutes: [Int], weekdays: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Reminder"
        content.body = "This notification will show up on Mondays and Fridays at 8:00 AM."
        content.sound = .default
        
        let calendar = Calendar.current
        
        // Schedule for Monday (weekday = 2)
        for (index, hour) in hours.enumerated() {
            let minute = minutes[index]
            let weekday = weekdays[index]
            
            var dateComponentsMonday = calendar.dateComponents([.year, .month, .day], from: Date())
            dateComponentsMonday.hour = hour
            dateComponentsMonday.minute = minute
            dateComponentsMonday.weekday = weekday
        
            let triggerMonday = UNCalendarNotificationTrigger(dateMatching: dateComponentsMonday, repeats: true)
            let requestMonday = UNNotificationRequest(identifier: "weeklyMondayNotification", content: content, trigger: triggerMonday)
        
            UNUserNotificationCenter.current().add(requestMonday) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    let weekdayString: String;
                    
                    switch(weekday)
                    {
                    case 1: weekdayString = "Sunday"
                    case 2: weekdayString = "Monday"
                    case 3: weekdayString = "Tuesday"
                    case 4: weekdayString = "Wednesday"
                    case 5: weekdayString = "Thursday"
                    case 6: weekdayString = "Friday"
                    case 7: weekdayString = "Saturday"
                    default: weekdayString = "This code will never be reached."
                    }
                    
                    print("Weekly notification scheduled for \(weekdayString) at \(hours):\(minutes).")
                }
            }
        }
    }
}
