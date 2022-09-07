//
//  PreferencesView.swift
//  Dicee Milestone
//
//  Created by Luis Rivera Rivera on 6/29/22.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var dice: Dice
    @State private var diceType: Int = 0
    @State private var diceCount: Int = 1
    @Environment (\.dismiss) var dismiss
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    
    
    var body: some View {
        VStack {
            Form {
                Section("Dice Sides") {
                    Picker("Dice Type", selection: $diceType) {
                        ForEach(0..<7) {
                            Text(String(diceTypes[$0]))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Stepper("Dice Count: \(diceCount)") {
                    diceCount += diceCount < 100 ? 1 : 0
                } onDecrement: {
                    diceCount -= diceCount > 1 ? 1 : 0
                }
                
                }
            
            Button("Save") {
                dice.setNewSettings(diceCount: diceCount, diceType: diceTypes[diceType])
                dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
        
        
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Dice Settings")
    }
    
    init(dice: Dice) {
        self.dice = dice
        _diceCount = State(initialValue: dice.diceCount)
        
        switch dice.diceType {
            
        case .fourSide:
            _diceType = State(initialValue: 0)
        case .sixSide:
            _diceType = State(initialValue: 1)
        case .eightSide:
            _diceType = State(initialValue: 2)
        case .tenSide:
            _diceType = State(initialValue: 3)
        case .twelveSide:
            _diceType = State(initialValue: 4)
        case .twentySide:
            _diceType = State(initialValue: 5)
        case .hundredSide:
            _diceType = State(initialValue: 6)
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(dice: Dice())
            .preferredColorScheme(.dark)
    }
}
