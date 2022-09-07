//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Luis Rivera Rivera on 4/12/22.
//

import Foundation

extension EditView {
    @MainActor class ViewModel: ObservableObject {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        @Published var name: String
        @Published var description: String
        @Published var loadingState: LoadingState
        @Published var pages = [Page]()
        var location: Location

        init(name: String, description: String, loadingState: LoadingState = .loading, pages: [Page], location: Location) {
            self.name = name
            self.description = description
            self.loadingState = loadingState
            self.pages = pages
            self.location = location
        }
        
        func newLocation() -> Location {
            var newLocation = location
            newLocation.name = name
            newLocation.description = description
            newLocation.id = UUID()
            return newLocation
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
    }
}
