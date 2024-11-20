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
    var decription: String = ""
    var time: Date = Date()
    var regularity: [Bool] = [false, false, false, false, false, false, false]
    var notification: Bool = false
    var duration: TimeInterval = 0
    var image: UIImage = UIImage()
    
    init(habit: Habit? = nil) {
        if let habit = habit {
            self.name = habit.name
            self.time = habit.time
            self.decription = habit.info
            self.regularity = habit.regularity
            self.notification = habit.notification
            self.duration = habit.duration
            self.image = habit.image
        }
    }

}
