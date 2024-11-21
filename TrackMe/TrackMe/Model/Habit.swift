//
//  HabitModel.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//

import Foundation
import UIKit
import SwiftData
@Model class Habit: Codable{
    
    var name: String
    var info: String
    var time: Date
    var regularity: [Bool] 
    var notification: Bool
    var duration: Date
    
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
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: duration)
        let minutes = calendar.component(.minute, from: duration)
        return String(format: "%02d:%02d", hours, minutes)
    }

    var formattedTime: String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            return formatter.string(from: time)
        
        
    }
    
    init(name: String, decription: String, time: Date, regularity: [Bool], notification: Bool, image: UIImage = UIImage(), duration: Date) {
        self.name = name
        self.info = decription
        self.time = time
        self.regularity = regularity
        self.notification = notification
        self.duration = duration
        self.image = image
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(info, forKey: .info)
        try container.encode(time, forKey: .time)
        try container.encode(regularity, forKey: .regularity)
        try container.encode(notification, forKey: .notification)
        try container.encode(duration, forKey: .duration)
        try container.encode(imageData, forKey: .imageData)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.info = try container.decode(String.self, forKey: .info)
        self.time = try container.decode(Date.self, forKey: .time)
        self.regularity = try container.decode([Bool].self, forKey: .regularity)
        self.notification = try container.decode(Bool.self, forKey: .notification)
        self.duration = try container.decode(Date.self, forKey: .duration)
        self.imageData = try container.decode(Data.self, forKey: .imageData)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, info, time, regularity, notification, duration, imageData
    }
}

extension Habit {
    static var dummyData = [
        Habit(name: "running", decription: "go for a run", time: Date(), regularity: [false, true], notification: true, image: UIImage(resource: .running), duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!)
    ]
}
