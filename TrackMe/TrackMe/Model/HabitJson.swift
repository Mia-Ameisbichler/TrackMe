//
//  HabitJson.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//

import Foundation
import UIKit

struct HabitJson: Codable {
    let name: String
    let info: String
    let time: String // Using ISO 8601 string format for JSON compatibility
    let regularity: [Bool]
    let notification: Bool
    let duration: String // Using a string to represent HH:mm
    let streak: Int
    let image: String // Name of the image file

    enum CodingKeys: String, CodingKey {
        case name
        case info
        case time
        case regularity
        case notification
        case duration
        case streak
        case image
    }
}

// Helper function to convert Date to ISO 8601 string
public func dateToISOString(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.string(from: date)
}

// Helper function to convert Date to HH:mm string
public func dateToHHMMString(_ date: Date) -> String {
    let calendar = Calendar.current
    let hours = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)
    return String(format: "%02d:%02d", hours, minutes)
}

// Helper function to convert ISO 8601 string to Date
public func isoStringToDate(_ isoString: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: isoString)
}

// Helper function to convert HH:mm string to Date
public func hhmmStringToDate(_ hhmmString: String) -> Date? {
    let components = hhmmString.split(separator: ":")
    guard components.count == 2,
          let hours = Int(components[0]),
          let minutes = Int(components[1]) else {
        return nil
    }
    return Calendar.current.date(from: DateComponents(
        year: 1970, month: 1, day: 1, // Default values for date
        hour: hours, minute: minutes
    ))
}

// Function to load HabitJson from a JSON API
func loadHabits(completion: @escaping (Result<[HabitJson], Error>) -> Void) {
    guard let url = URL(string: "https://your.api.endpoint/habits.json") else {
        completion(.failure(URLError(.badURL)))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        guard let data = data else {
            completion(.failure(URLError(.cannotLoadFromNetwork)))
            return
        }

        do {
            let decodedHabits = try JSONDecoder().decode([HabitJson].self, from: data)
            DispatchQueue.main.async {
                completion(.success(decodedHabits))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
