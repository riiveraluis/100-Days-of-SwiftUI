//
//  ContentView.swift
//  Dicee Milestone
//
//  Created by Luis Rivera Rivera on 6/28/22.
//

import CoreHaptics
import SwiftUI

struct ContentView: View {
    @StateObject var dice = Dice()
    @State private var engine: CHHapticEngine?
    @State private var isShowingSettings = false
    @State private var isShuffling = false
    @State private var shuffles = 0

    let columns = [
        GridItem(.adaptive(minimum: 85))
]
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<dice.diceCount, id: \.self) { index in
                                DiceView(diceValue: dice.dices[index])
                            }
                        }
                    }
                    .frame(height: geo.size.height * 0.4)
                    Divider()
                      
                    
                    if dice.results.isEmpty {
                        StartingInstructions()
                            .frame(height: geo.size.height * 0.4)

                    } else {
                        ResultListView(results: dice.results)
                    }
                    
                    Button("Roll Dice's", action: rollDice)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                        )
                        .padding(.top)
                }
                .disabled(isShuffling)
            }
            .navigationTitle("Dice Roller")
            .toolbar {
                Button {
                    isShowingSettings.toggle()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                PreferencesView(dice: dice)
            }
            .onReceive(timer) { _ in
                if isShuffling && shuffles < 5 {
                    dice.mockShuffle()
                    shuffles += 1
                } else if isShuffling && shuffles == 5 {
                    dice.shuffle()
                    shuffles = 0
                    isShuffling.toggle()
                }
            }
            .onShake(perform: rollDice)
            .onAppear(perform: prepareHaptics)
            .onChange(of: shuffles) { _ in
                guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
                   var events = [CHHapticEvent]()

                   // create one intense, sharp tap
                   let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                   let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
                   let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
                   events.append(event)

                   // convert those events into a pattern and play it immediately
                   do {
                       let pattern = try CHHapticPattern(events: events, parameters: [])
                       let player = try engine?.makePlayer(with: pattern)
                       try player?.start(atTime: 0)
                   } catch {
                       print("Failed to play pattern: \(error.localizedDescription).")
                   }
            }
        }
    }
        
    
    func rollDice() {
        isShuffling.toggle()
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct StartingInstructions: View {
    var body: some View {
        VStack {
            Text("To configure dice count and type access the geared icon.\n\nThese instructions will be replaced with the roll results after first roll.\n\nAlso you can shake the device to roll the dices")
                .font(.subheadline)
                .fontWeight(.heavy)
        }
    }
}

struct ResultListView: View {
    var results: [Result]
    var body: some View {
        List {
            Section("Previous Results") {
                ForEach(results, id: \.id) { result in
                    Text("\(result.points) points from \(result.diceCount) \(result.diceTypeDescription)")
                }
            }
        }
    }
}
