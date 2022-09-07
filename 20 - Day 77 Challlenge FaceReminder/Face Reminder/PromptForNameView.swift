//
//  PromptForNameView.swift
//  Face Reminder
//
//  Created by Luis Rivera Rivera on 6/17/22.
//

import SwiftUI
import CoreLocation

struct PromptForNameView: View {
    let image: UIImage
    let locationFetcher = LocationFetcher()
    @State private var currentLocation: CLLocationCoordinate2D?
    
    @State private var name = ""
    @ObservedObject var people: People
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                    
                    Text("Who is this?")
                        .font(.subheadline.weight(.bold))
                }
                .frame(height: geometry.size.height * 0.45, alignment: .center)
                Divider()
                Form {
                    Section ("What is the name of the person on the photo?") {
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Section ("Optional Information") {
                        Button("Add current location") {
                            if let location = self.locationFetcher.lastKnownLocation {
                                self.currentLocation = location
                                print("Your Location is \(currentLocation!)")
                            } else {
                                print("Could not obtain Location")
                            }
                        }
                    }
                    
                    Button("Add person") {
                        guard let currentLocation = currentLocation else {
                            let personToBeAdded = Person(id: UUID(), name: name, photo: image.pngData()!, photoLocation: nil)
                            people.add(personToBeAdded)
                            dismiss()
                            return
                        }
                        
                        let personToBeAdded = Person(id: UUID(), name: name, photo: image.pngData()!, photoLocation: PhotoLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
                        people.add(personToBeAdded)
                        dismiss()
                    }
                }
            }
        }
        .onAppear{
            self.locationFetcher.start()
        }
    }
}

struct PromptForNameView_Previews: PreviewProvider {
    static var previews: some View {
        PromptForNameView(image: UIImage(named: "steve")!, people: People())
    }
}

