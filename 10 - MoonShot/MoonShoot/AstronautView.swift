//
//  AstronautView.swift
//  MoonShoot
//
//  Created by Luis Rivera Rivera on 1/11/22.
//

import SwiftUI


struct AstronautView: View {
    let astronaut: Astronaut

    var body: some View {
        ScrollView {
            VStack {
                
            
            Image(astronaut.id)
                .resizable()
                .scaledToFit()
                
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        let astronaut: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        
        AstronautView(astronaut: astronaut["armstrong"]!)
            .preferredColorScheme(.dark)
    }
}
