//
//  ContentView.swift
//  Accessibility app
//
//  Created by Luis Rivera Rivera on 8/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 3
    
    var body: some View {
        TabView(selection: $selection) {
            
            ImageView()
                .tabItem {
                    Label("Image", systemImage: "doc.text.image")
                }
                .tag(0)
            
            CharacterDecorativeView()
                .tabItem {
                    Label("Character", systemImage: "person")
                }
                .tag(1)
            
            CustomValueView()
                .tabItem {
                    Label("Custom Value", systemImage: "button.programmable")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
