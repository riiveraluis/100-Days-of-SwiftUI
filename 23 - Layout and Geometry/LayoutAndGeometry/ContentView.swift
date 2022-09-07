//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Luis Rivera Rivera on 6/21/22.
//

import SwiftUI

struct customScaleEffect: ViewModifier {
    var geometry: GeometryProxy
    
    func body(content: Content) -> some View {
        switch geometry.frame(in: .global).midY {
        case 0..<100:
            content
                .scaleEffect(0.50)
        case 100..<200:
            content
                .scaleEffect(0.60)
        case 200..<300:
            content
                .scaleEffect(0.70)
        case 300..<400:
            content
                .scaleEffect(0.80)
        case 400...:
            content
                .scaleEffect(1)
        default:
            content
        }
            
    }
}

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % 7])
                            .opacity(geo.frame(in: .global).midY / 200)
                            .modifier(customScaleEffect(geometry: geo))
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                        Text("Coordinate \(geo.frame(in: .global).midY)")
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
