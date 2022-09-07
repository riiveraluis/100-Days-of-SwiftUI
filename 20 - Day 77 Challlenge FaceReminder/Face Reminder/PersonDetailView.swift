//
//  PersonDetailView.swift
//  Face Reminder
//
//  Created by Luis Rivera Rivera on 6/17/22.
//

import SwiftUI

struct PersonDetailView: View {
    var person: Person
    @State private var showingImageLocation = false
    @State private var showImageWithNoLocationError = false
    
    var body: some View {
       
        VStack(spacing: 25) {
                Image(uiImage: UIImage(data: person.photo)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Button("See image location") {
                    if person.photoLocation != nil {
                    showingImageLocation.toggle()
                    } else {
                        showImageWithNoLocationError.toggle()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
            .navigationTitle(person.name)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showingImageLocation, content: {
                MapView(photoLocation: person.photoLocation!)
            })
            .alert("Image with no location data", isPresented: $showImageWithNoLocationError) {}
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PersonDetailView(person: Person(id: UUID(), name: "Luis", photo: UIImage(named: "steve")!.pngData()!, photoLocation: PhotoLocation(latitude: 37.334886, longitude: -122.008988)))
        }
    }
}
