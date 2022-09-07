//
//  ContentView.swift
//  Day 25 Challenge Rock, papers and sscissors
//
//  Created by Luis Rivera Rivera on 12/15/21.
//

import SwiftUI

struct Card: View {
    var emoji: String
    
    var emojiSymbol: String {
        switch emoji {
        case "rock":
            return "🪨"
        case "papers":
            return "📃"
        case "scissors":
            return "✂️"
            
        default:
            fatalError()
        }
    }
    
    var body: some View {
        VStack {
            Text(emojiSymbol)
                .font(.system(size: 75))
            Text(emoji.uppercased())
            
        }.frame(width: 100, height: 100, alignment: .center)
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    var cardTypes = ["rock", "papers", "scissors"]
    
    //MARK: - State Section
    @State private var turn = 0
    @State private var playerScore = 0
    
    @State private var computerMove = Int.random(in: 0...2)
    @State private var moveStrategy: [Scenario] = [.win, .lose, .win, .lose, .win, .lose, .win, .lose, .win, .lose]
    @State private var showingEndGameAlert = false
    
    //MARK: - enum Section
    enum Scenario: String {
        case win, lose
    }
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.1),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.1)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("Brain Trainer")
                    .prominentTitle()
                
                Text("Computer Move:")
                    .foregroundColor(.white)
                
                switch computerMove {
                case 0:
                    Text("🪨").font(.system(size: 75))
                case 1:
                    Text("📃").font(.system(size: 75))
                case 2:
                    Text("✂️").font(.system(size: 75))
                default:
                    fatalError()
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    if moveStrategy[turn] == .win {
                        Text("Tap the move to win")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.bold))
                    } else {
                        Text("Tap the move to lose")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.semibold))
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(cardTypes, id: \.self) { name in
                            Button {
                                cardTapped(name)
                            } label: {
                                Card(emoji: name)
                            }
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(playerScore)")
                    .prominentTitle()
                Spacer()
                
            }.padding()
        }.alert("Game Ended!", isPresented: $showingEndGameAlert) {
            Button("Play again", action: createNewGame)
        } message: {
            Text("Your final score is \(playerScore)")
        }
    }
    
    func cardTapped(_ name: String) {
        // Do logic to determine if the player made the right move.
        
        if moveStrategy[turn] == .win {
            switch computerMove {
            case 0: // Rock
                if name == "papers" {
                    playerScore += 1
                }
            case 1: // Paper
                if name == "scissors" {
                    playerScore += 1
                }
            case 2: // Scissors
                if name == "rock" {
                    playerScore += 1
                }
            default:
                fatalError()
            }
        } else { // Lose Strategy
            switch computerMove {
            case 0: // Rock
                if name == "scissors" {
                    playerScore += 1
                }
            case 1: // Paper
                if name == "rock" {
                    playerScore += 1
                }
            case 2: // Scissors
                if name == "papers" {
                    playerScore += 1
                }
            default:
                fatalError()
            }
        }
        
        nextRound()
    }
    
    func nextRound() {
        if turn == 9 {
            showingEndGameAlert = true
        } else {
            
            computerMove = Int.random(in: 0...2)
            turn += 1
        }
    }
    
    func createNewGame() {
        playerScore = 0
        turn = 1
        computerMove = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}
