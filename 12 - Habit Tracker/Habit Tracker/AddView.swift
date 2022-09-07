//
//  AddView.swift
//  Habit Tracker
//
//  Created by Luis Rivera Rivera on 3/13/22.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var activities: Activities
    @Environment(\.dismiss) var dismiss
    @State var name = ""
    @State var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Name", text: $name)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add Habit")
            .toolbar {
                Button("Save") {
                    let habit = Habit(title: name, description: description)
                    activities.activities.append(habit)
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(activities: Activities())
    }
}
