//
//  ImageView.swift
//  Accessibility app
//
//  Created by Luis Rivera Rivera on 8/24/22.
//

import SwiftUI

struct ImageView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]
    
    @State private var selectedPicture = Int.random(in: 0...3)
    
    var body: some View {
        VStack {
            Image(pictures[selectedPicture])
                .resizable()
                .scaledToFit()
                .accessibilityLabel(labels[selectedPicture])
                .onTapGesture {
                    selectedPicture = Int.random(in: 0...3)
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityRemoveTraits(.isImage)
            
            Text("Use voiceover to experience accessibility traits and labels.")
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
