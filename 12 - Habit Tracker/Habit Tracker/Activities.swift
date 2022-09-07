//
//  Activities.swift
//  Habit Tracker
//
//  Created by Luis Rivera Rivera on 3/11/22.
//

import Foundation

class Activities: ObservableObject {
    @Published var activities = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "activities")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "activities") {
            if let decodedActivities = try? JSONDecoder().decode([Habit].self, from: savedItems) {
                activities = decodedActivities
                return
            }
        }
        activities = []
    }
}
