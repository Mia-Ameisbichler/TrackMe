import SwiftUI
import UserNotifications

struct Notification {
    var habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    func scheduleNewNotification() {
        guard habit.notification else {
            print("Notifications are disabled for this habit.")
            return
        }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: habit.time)
        let minute = calendar.component(.minute, from: habit.time)

        // Extract active weekdays
        let activeWeekdays = habit.regularity.enumerated().compactMap { index, isActive in
            isActive ? index + 1 : nil // Convert index to weekday (1 = Sunday, 7 = Saturday)
        }

        if habit.regularity.allSatisfy({ $0 }) {
            // All values are true, so schedule a daily notification
            print("All weekdays selected. Scheduling a daily notification for habit: \(habit.name)")
            scheduleDailyNotification(hour: hour, minute: minute)
        } else if habit.regularity.allSatisfy({ !$0 }) {
            // All values are false, so schedule a daily notification
            print("No specific weekdays selected. Scheduling a daily notification for habit: \(habit.name)")
            scheduleDailyNotification(hour: hour, minute: minute)
        } else {
            // Specific weekdays are selected, schedule weekly notifications
            print("Scheduling weekly notifications for habit: \(habit.name) on days: \(activeWeekdays)")
            scheduleWeeklyNotificationOnSpecificDays(
                hours: Array(repeating: hour, count: activeWeekdays.count),
                minutes: Array(repeating: minute, count: activeWeekdays.count),
                weekdays: activeWeekdays
            )
        }
    }
    
    // Single Use Notification
    func scheduleReminderNotification() {
        let content = createNotificationContent(title: "Reminder", body: "This notification will show up when the User chose to be reminded later")
        
        // Calculate the trigger date 30 minutes from now
        let triggerDate = Date().addingTimeInterval(30 * 60) // 30 minutes in seconds
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        
        // Create a non-repeating trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        scheduleNotification(with: content, identifier: "reminderNotification", trigger: trigger)
    }
    
    // Daily Notification
    func scheduleDailyNotification(hour: Int, minute: Int) {
        let content = createNotificationContent(title: "Daily Reminder", body: "This notification will show up every day at the selected time.")
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        scheduleNotification(with: content, identifier: "dailyReminderNotification", trigger: trigger)
    }
    
    // Multiple Notifications per Day
    func scheduleMultipleNotifications(hours: [Int], minutes: [Int]) {
        let content = createNotificationContent(title: "Multiple Notifications", body: "This notification appears multiple times during the day.")
        
        for (index, hour) in hours.enumerated() {
            let minute = minutes[index]
            
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            dateComponents.hour = hour
            dateComponents.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            scheduleNotification(with: content, identifier: "notification-\(hour)-\(minute)", trigger: trigger)
        }
    }
    
    // Weekly Notification on Specific Days
    func scheduleWeeklyNotificationOnSpecificDays(hours: [Int], minutes: [Int], weekdays: [Int]) {
        let content = createNotificationContent(title: "Weekly Reminder", body: "This notification will show up on selected weekdays.")
        
        for (index, hour) in hours.enumerated() {
            let minute = minutes[index]
            let weekday = weekdays[index]
            
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            scheduleNotification(with: content, identifier: "weeklyNotification-\(weekday)-\(hour)-\(minute)", trigger: trigger)
        }
    }
    
    // Helper: Create Notification Content
    private func createNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Serialize Habit into JSON
        let encoder = JSONEncoder()
        if let habitData = try? encoder.encode(habit) {
            content.userInfo = ["habit": habitData]
        } else {
            print("Failed to encode habit for notification userInfo.")
        }
        
        return content
    }
    
    // Helper: Schedule a Notification
    private func scheduleNotification(with content: UNMutableNotificationContent, identifier: String, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled: \(identifier)")
            }
        }
    }
}
