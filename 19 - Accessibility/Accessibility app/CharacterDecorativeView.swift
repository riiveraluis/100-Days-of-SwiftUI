//
//  CharacterDecorativeView.swift
//  Accessibility app
//
//  Created by Luis Rivera Rivera on 8/24/22.
//

import SwiftUI

struct CharacterDecorativeView: View {
    var body: some View {
        VStack {
            Image("Iron Man")
                .resizable()
                .scaledToFit()
            
            Text("This image will read normal voice over prompts")
            
            
            Image(decorative: "Iron Man")
                .resizable()
                .scaledToFit()
                .accessibilityHidden(true)
            
            Text("This image will read no voice over prompts")
            
            Spacer()

            Text("The following labels will demonstrate different voice over reading modes. The first one will read separately, the second one will be continuously will a slight pause and the last one will be read continuously.")
            
            VStack {
                Text("Your score is")
                Text("3000")
                    .font(.title)
            }
            
            VStack {
                Text("Your score is")
                Text("3000")
                    .font(.title)
            }
            .accessibilityElement(children: .combine)
            
            VStack {
                Text("Your score is")
                Text("3000")
                    .font(.title)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Your score is 3000")
        }
        .padding(.horizontal)
    }
}

struct CharacterDecorativeView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDecorativeView()
    }
}
