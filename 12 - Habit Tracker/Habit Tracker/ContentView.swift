//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Luis Rivera Rivera on 3/11/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var activities = Activities()
    @State private var showAddingForm = false
    
    var body: some View {
        NavigationView {
            Group {
                
                if !activities.activities.isEmpty {
                    List {
                        ForEach(activities.activities) { activity in
                            NavigationLink {
                                DetailView(habit: activity, activities: activities)
                            } label: {
                                Text(activity.title)
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                } else {
                    AddHintList()
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                Button {
                    showAddingForm.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddingForm) {
                AddView(activities: activities)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.activities.remove(atOffsets: offsets)
    }
}

struct AddHintList: View {
    var body: some View {
        List {
            Text("Start adding a new habit pressing the plus button above")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

