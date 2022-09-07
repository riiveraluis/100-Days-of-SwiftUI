//
//  ViewDetailView.swift
//  Habit Tracker
//
//  Created by Luis Rivera Rivera on 3/13/22.
//

import SwiftUI

enum SavingMode {
    case incrementActivity
    case saveDetails
}

struct DetailView: View {
    var habit: Habit
    @ObservedObject var activities: Activities
    
    @State private var name: String
    @State private var description: String
    
    var habitActivityDescription: String {
        habit.timesDone != 0 ?
        "Activity done \(habit.timesDone) times" :
        "Activity never done before"
    }
    
    init(habit: Habit, activities: Activities) {
        self.habit = habit
        self.activities = activities
        
        _name = State(initialValue: habit.title)
        _description = State(initialValue: habit.description)
    }
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Habit name", text: $name, prompt: Text("Habit name"))
            }
            
            Section("Description") {
                TextField("Habit Description", text: $description, prompt: Text("Habit Description"))
            }
            
            Text(habitActivityDescription)
            
            Button("Increment Times Done") {
                save(mode: .incrementActivity)
            }
        }
        .toolbar(content: {
            Button("Save") {
                save(mode: .saveDetails)
            }
        })
        .navigationTitle("Habit Details")
        .navigationBarTitleDisplayMode(.inline)

        }
    
    func save(mode: SavingMode) {
        let newHabit: Habit
        
        if mode == .incrementActivity {
            newHabit = Habit(title: name, description: description, timesDone: habit.timesDone + 1)
        } else {
            newHabit = Habit(title: name, description: description, timesDone: habit.timesDone)
        }
        
        let index = activities.activities.firstIndex(of: habit)!
        activities.activities[index] = newHabit
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static let habit = Habit(title: "Testing", description: "Testing Description", timesDone: 0)
    static let activities = Activities()
    static var previews: some View {
        NavigationView {
            DetailView(habit: habit, activities: activities)
        }
    }
}

