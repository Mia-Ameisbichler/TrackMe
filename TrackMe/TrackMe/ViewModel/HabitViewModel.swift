//
//  HabitViewModel.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//
import Foundation
import SwiftUI

@Observable class HabitViewModel {
    var name: String = ""
    var info: String = ""
    var time: Date = Date()
    var regularity: [Bool] = [false, false, false, false, false, false, false]
    var notification: Bool = false
    var duration: Date = Date()
    var image: UIImage = UIImage()
    var streak: Int = 0
    
    init(habit: Habit? = nil) {
        if let habit = habit {
            self.name = habit.name
            self.time = habit.time
            self.info = habit.info
            self.regularity = habit.regularity
            self.notification = habit.notification
            self.duration = habit.duration
            self.image = habit.image
            self.streak = habit.streak
        }
    }

}
