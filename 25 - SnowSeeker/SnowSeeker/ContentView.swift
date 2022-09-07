//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Luis Rivera Rivera on 4/21/22.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyStackNavigation() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

enum SortType {
    case defaultOrder, alphabetical, country
}

struct ContentView: View {
    @State private var resorts = Resort.allResorts
    @State private var searchText = ""
    @State private var showingSortOptions = false
    @State private var sortType: SortType = .defaultOrder
    @StateObject var favorites = Favorites()
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This a favorite resort.")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    showingSortOptions.toggle()
                } label: {
                    Text("Sort")
                }
            }
            .confirmationDialog("Sorted by", isPresented: $showingSortOptions, titleVisibility: .visible) {
                Button("Default Order") {
                    sortType = .defaultOrder
                }
                Button("Alphabetical") {
                    sortType = .alphabetical
                }
                Button("County") {
                    sortType = .country
                }
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .navigationTitle("Resorts")
            
            
            WelcomeView()
        }
        .environmentObject(favorites)
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var sortedResorts: [Resort] {
        switch sortType {
        case .defaultOrder:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { $0.name < $1.name}
        case .country:
            return filteredResorts.sorted { $0.country < $1.country}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
