//
//  Habit.swift
//  Habit Tracker
//
//  Created by Luis Rivera Rivera on 3/11/22.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    var title: String
    var description: String
    var timesDone: Int
    var id = UUID()
    
    init(title: String, description: String, timesDone: Int = 0, id: UUID = UUID()) {
        self.title = title
        self.description = description
        self.timesDone = timesDone
        self.id = id
    }
}
