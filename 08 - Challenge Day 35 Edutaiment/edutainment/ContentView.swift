//
//  ContentView.swift
//  Day 35 Challenge edutainment
//
//  Created by Luis Rivera Rivera on 12/30/21.
//

import SwiftUI

struct KeypadButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .foregroundColor(.black)
            .clipShape(Circle())
            .frame(width: 75, height: 75)
    }
}

extension View {
    func KeypadButtonStyle() -> some View {
        modifier(KeypadButtonStyleModifier())
    }
}

struct Question {
    var operand1: Int
    var operand2: Int
    
    var answer: Int {
        operand1 * operand2
    }
}

struct ContentView: View {
    @State private var gameIsActive = false
    @State private var selectedTable = 2
    var questionsOptions = [5, 10, 20]
    @State private var numberOfQuestions = 5
    @State private var questionsAsked = 1
    
    @State private var questions = [Question]()
    @State private var answer = ""
    @State private var correctAnswers = 0
    
    @State private var isErrorAlertShowing = false
    @State private var showingEndGameAlert = false

    var body: some View {
        if !gameIsActive {
            NavigationView {
                Form {
                    Section("Select the table to practice") {
                        Picker("Table", selection: $selectedTable) {
                            ForEach (2..<13, id: \.self) { table in
                                Text("of \(table)")
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("How many questions") {
                        Picker("Questions", selection: $numberOfQuestions) {
                            ForEach(questionsOptions, id: \.self) {
                                Text($0, format: .number)
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    HStack {
                        Spacer()
                        Button("Begin", action: startGame)
                        Spacer()
                    }
                }
                .navigationTitle("Edutainment Setup")
            }
        } else {
            ZStack {
                LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Practice of \(selectedTable) table")
                        .font(Font.largeTitle)
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Question: \(questionsAsked) of \(numberOfQuestions)")
                            .font(Font.headline)
                            .foregroundColor(.white)
                    }
                    
                    // Dynamic question section
                    HStack {
                        Text("\(questions[questionsAsked - 1].operand1)")
                            .fontWeight(Font.Weight.heavy)
                            .foregroundColor(Color.red)
                        Text("X")
                            .fontWeight(Font.Weight.heavy)
                            .foregroundColor(Color.red)
                        
                        Text("\(questions[questionsAsked - 1].operand2)")
                            .fontWeight(Font.Weight.heavy)
                            .foregroundColor(Color.blue)
                    }.font(.largeTitle)
                    
                    TextField("Answer", text: $answer)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    // Button Creation component
                    VStack(alignment: .trailing, spacing: 25) {
                        HStack(spacing: 50) {
                            Button("1") {
                                addToTextField("1")
                            }
                            .KeypadButtonStyle()
                            
                            Button("2") {
                                addToTextField("2")
                            }
                            .KeypadButtonStyle()
                            
                            Button("3") {
                                addToTextField("3")
                            }
                            .KeypadButtonStyle()
                        }
                        
                        HStack(spacing: 50) {
                            Button("4") {
                                addToTextField("4")
                            }
                            .KeypadButtonStyle()
                            
                            Button("5") {
                                addToTextField("5")
                            }
                            .KeypadButtonStyle()
                            
                            Button("6") {
                                addToTextField("6")
                            }
                            .KeypadButtonStyle()
                        }
                        
                        HStack(spacing: 50) {
                            Button("7") {
                                addToTextField("7")
                            }
                            .KeypadButtonStyle()
                            
                            Button("8") {
                                addToTextField("8")
                            }
                            .KeypadButtonStyle()
                            
                            Button("9") {
                                addToTextField("9")
                            }
                            .KeypadButtonStyle()
                        }
                          
                        HStack(spacing: 50) {
                            Button("") {}
                                .KeypadButtonStyle()
                                .opacity(0)
                            
                            Button("0") {
                                addToTextField("0")
                            }
                            .KeypadButtonStyle()
                            
                            
                            Button {
                                answer.removeLast()
                            } label: {
                                Image(systemName: "delete.backward")
                            }
                            .KeypadButtonStyle()
                        }
                                            }
                    .foregroundColor(Color.accentColor)
                    
                    Button("Submit", action: guess)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.top)
                }
            }
            .alert(isPresented: $isErrorAlertShowing) {
                Alert(title: Text("Error"), message: Text("Please enter a valid number."), dismissButton: .default(Text("Got it!")))
                
            }
            .alert("Results", isPresented: $showingEndGameAlert) {
                Button("Play again", action: createNewGame)
            } message: {
                Text("You got \(correctAnswers) of \(numberOfQuestions)")
            }
        }
    }
    
    func startGame() {
        questions.removeAll(keepingCapacity: true)
        print(questions)
        generateQuestions()
        gameIsActive = true
    }
    
    func generateQuestions() {
        for _ in 0...numberOfQuestions {
            questions.append(Question(operand1: selectedTable, operand2: Int.random(in: 1...12)))
        }
    }
    
    func createNewGame() {
        gameIsActive = false
        correctAnswers = 0
        questionsAsked = 1
    }
    
    func addToTextField(_ num: String) {
        answer += num
    }
    
    func guess() {
        guard let userAnswer = Int(answer) else {
            isErrorAlertShowing.toggle()
            return
        }
        
        print("User answer: \(userAnswer)")
        if userAnswer == questions[questionsAsked - 1].answer {
            print("Right!")
            correctAnswers += 1
            
        } else {
            print("Wrong!")
        }
        
        if questionsAsked < numberOfQuestions {
            questionsAsked += 1
        } else {
            showingEndGameAlert = true
        }
        
        answer.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
