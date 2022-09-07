//
//  ContentView.swift
//  Face Reminder
//
//  Created by Luis Rivera Rivera on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var group = People()
    @State private var imageSelected: UIImage?
    
    // Showing States
    @State private var showingImagePicker = false
    @State private var showingPromptName = false
    
    var body: some View {
        NavigationView {
            Group {
                if !filteredPeople.isEmpty {
                    List(filteredPeople) { person in
                        NavigationLink {
                            PersonDetailView(person: person)
                        } label: {
                            Image(uiImage: UIImage(data: person.photo)!)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            Text(person.name)
                        }
                        .swipeActions {
                            Button {
                                group.remove(person)
                                
                            } label: {
                                Label("Remove person from list", systemImage: "trash")
                            }
                        }
                    }
                } else {
                    EmptyListView()
                }
            }
            .navigationBarTitle("Face Reminder")
            .toolbar {
                Button {
                    showingImagePicker.toggle() }
            label: {
                Label("Add new person", systemImage: "plus")
            }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $imageSelected)
        }
        .fullScreenCover(isPresented: $showingPromptName, content: {
            PromptForNameView(image: imageSelected!, people: group)
        })
        .onChange(of: imageSelected) { newValue in
            showingPromptName.toggle()
        }
    }
    
    var filteredPeople: [Person] {
        group.people.sorted { lhs, rhs in
            lhs.name < rhs.name
        }
    }
}

struct EmptyListView: View {
    var body: some View {
        VStack {
            Group {
                Image(systemName: "person.3.sequence.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                
                Text("Start adding people by pressing \(Image(systemName: "plus")) icon above")
                    .font(.headline)
            }
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
