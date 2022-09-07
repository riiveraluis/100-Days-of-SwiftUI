//
//  MapView.swift
//  Face Reminder
//
//  Created by Luis Rivera Rivera on 6/17/22.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    let photoLocation: PhotoLocation
    let annotatedItems: [AnnotatedItem]
    @State private var region: MKCoordinateRegion
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: annotatedItems) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                            
                        Text(item.name)
                            .fixedSize()
                    }
                }
                
            }
            .edgesIgnoringSafeArea([.horizontal, .bottom])
        }
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
    }
    
    init(photoLocation: PhotoLocation) {
        self.photoLocation = photoLocation
        self.annotatedItems = [AnnotatedItem(id: UUID(), name: "Meeted here!", coordinate: CLLocationCoordinate2D(latitude: photoLocation.latitude, longitude: photoLocation.longitude))]
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: photoLocation.latitude, longitude: photoLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(photoLocation: PhotoLocation(latitude: 37.334886, longitude: -122.008988))
    }
}
