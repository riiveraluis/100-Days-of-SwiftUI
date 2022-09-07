//
//  ContentView.swift
//  Project 2 Guess The Flag
//
//  Created by Luis Rivera Rivera on 12/12/21.
//

import SwiftUI

//Challenge 2 Day 24

struct FlagImage: View {
    var imageName: String
    @State private var isSpinning = false
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

// Challenge 3 Day 24
struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var showingAlert = false
    @State private var scoreTitle = ""
    
    @State private var userScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "UK", "US"].shuffled()
    
    // Project 2 Challenge
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var questionAsked = 1
    @State private var showGameEndAlert = false
    @State private var alertMessage = ""
    
    // Animation Challenge
    @State private var rotationAmount = 0.0
    @State private var cardsNotSelected = Array(repeating: false, count: 3)
    
    //Accessibility Labels
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                }
                .foregroundColor(Color.white)
                .accessibilityElement()
                .accessibilityLabel("Tap the flag of \(countries[correctAnswer])")
                
                ForEach(0..<3) { number in
                    Button {
                        // Flag was tapped
                        flagTapped(number)
                    } label: {
                        FlagImage(imageName: countries[number])
                            .rotation3DEffect(.degrees(!cardsNotSelected[number] ? rotationAmount : -rotationAmount), axis: (x: 0, y: 1, z: 0))
                            .opacity(cardsNotSelected[number] ? 0.25 : 1.0)
                            .scaleEffect()
                            .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                    }
                }
                
                Text("Score: \(userScore)")
                    .prominentTitle()
            }
        }
        .alert(scoreTitle, isPresented: $showingAlert) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert("Final Score", isPresented: $showGameEndAlert) {
            Button("Retry", action: reset)
        } message: {
            Text("Your final score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        for index in 0...2 {
            if index == number {
                cardsNotSelected[index] = false
            } else {
                cardsNotSelected[index] = true
            }
        }
        
        withAnimation {
            rotationAmount += 360
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
            alertMessage = "Your score is \(userScore)"
        } else {
            scoreTitle = "Wrong!"
            alertMessage = "That's the flag of \(countries[number])"
            userScore -= 1
        }
        
        if questionAsked != 8 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingAlert = true
            }
        } else {
            showGameEndAlert = true
        }
    }
    
    func askQuestion() {
        questionAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        cardsNotSelected = Array(repeating: false, count: 3)
        rotationAmount = 0.0
    }
    
    func reset() {
        questionAsked = 1
        userScore = 0
        askQuestion()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
