//
//  CustomValueView.swift
//  Accessibility app
//
//  Created by Luis Rivera Rivera on 8/24/22.
//

import SwiftUI

struct CustomValueView: View {
    
    @State private var value = 10
    var body: some View {
        VStack {
            Text("Value: \(value)")
            
            Button("Increment") {
                value += 1
            }
            
            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            @unknown default:
                fatalError("New direction detected on Apple's framework.")
            }
        }
    }
}

struct CustomValueView_Previews: PreviewProvider {
    static var previews: some View {
        CustomValueView()
    }
}
