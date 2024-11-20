//
//  HabitModel.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//

import Foundation
import UIKit
import SwiftData
@Model class Habit {
    
    var name: String
    var info: String
    var time: Date
    var regularity: [Bool] 
    var notification: Bool
    var duration: TimeInterval // Duration in seconds
    
    @Attribute(.externalStorage) var imageData = Data()
    
    @Transient var image: UIImage {
        get {
            UIImage(data: imageData) ?? UIImage()
        }
        
        set {
            self.imageData = newValue.pngData() ?? Data()
        }
        
    }
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    var formattedTime: String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short // "3:15 PM" style
            formatter.dateStyle = .none // Only time, no date
            return formatter.string(from: time)
        
        
    }
    
    init(name: String, decription: String, time: Date, regularity: [Bool], notification: Bool, image: UIImage = UIImage(), duration: TimeInterval) {
        self.name = name
        self.info = decription
        self.time = time
        self.regularity = regularity
        self.notification = notification
        self.duration = duration
        self.image = image
        
    }
}

extension Habit {
    static var dummyData = [
        Habit(name: "running", decription: "go for a run", time: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!, regularity: [false, true], notification: true, image: UIImage(resource: .running), duration: 300)
    ]
}
