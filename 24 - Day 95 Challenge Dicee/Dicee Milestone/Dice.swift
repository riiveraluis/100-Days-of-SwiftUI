//
//  Dice.swift
//  Dicee Milestone
//
//  Created by Luis Rivera Rivera on 7/1/22.
//

import Foundation
import SwiftUI

struct Result: Identifiable, Codable {
    var id = UUID()
    var points: Int
    var diceType: DiceType
    var diceCount: Int
    
    var diceTypeDescription: String {
        switch diceType {
        case .fourSide:
            return "four-side dice"
        case .sixSide:
            return "six-side dice"
        case .eightSide:
            return "eight-side dice"
        case .tenSide:
            return "ten-side dice"
        case .twelveSide:
            return "twelve-side dice"
        case .twentySide:
            return "twenty-side dice"
        case .hundredSide:
            return "hundred-side dice"
        }
    }
}

enum DiceType: Codable {
case fourSide, sixSide, eightSide, tenSide, twelveSide, twentySide, hundredSide
}

@MainActor class Dice: ObservableObject {
    @Published private(set) var dices: [Int]
    @Published private(set) var results: [Result]
    @Published private(set) var diceType: DiceType
    @Published private(set) var diceCount: Int
    
    var posibleNumbers: [Int] {
        var numbers = [Int]()
        switch diceType {
        case .fourSide:
            for number in 1...4 {
                numbers.append(number)
            }
        case .sixSide:
            for number in 1...6 {
                numbers.append(number)
            }
        case .eightSide:
            for number in 1...8 {
                numbers.append(number)
            }
        case .tenSide:
            for number in 1...10 {
                numbers.append(number)
            }
        case .twelveSide:
            for number in 1...12 {
                numbers.append(number)
            }
        case .twentySide:
            for number in 1...20 {
                numbers.append(number)
            }
        case .hundredSide:
            for number in 1...100 {
                numbers.append(number)
            }
        }
    return numbers
    }
    
    var totalRolled: Int {
        var sum = 0
        
        for dice in dices {
            sum += dice
        }
        
        return sum
    }
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("results")
    
    init(diceType: DiceType = DiceType.sixSide, diceCount: Int = 5) {
        self.dices = Array(repeating: 1, count: diceCount)
        self.diceType = diceType
        self.diceCount = diceCount
        
        do {
            let data = try Data(contentsOf: savePath)
            results = try JSONDecoder().decode([Result].self, from: data)
            
        } catch {
            print("Error getting previous data")
            self.results = [Result]()
        }
        }
    
    func shuffle() {
        print("Before \(dices)")

        for index in 0..<diceCount {
            dices[index] = posibleNumbers.randomElement()!
        }
        
        print("After \(dices)")
        createDiceResults()
    }
    
    func mockShuffle() {
        for index in 0..<diceCount {
            dices[index] = posibleNumbers.randomElement()!
        }
    }
    
    private func createDiceResults() {
        results.insert(Result(points: totalRolled, diceType: diceType, diceCount: diceCount), at: 0)
        save()
    }
    
    func setNewSettings(diceCount: Int, diceType: Int) {
        let newDiceType: DiceType
        self.diceCount = diceCount
        
        dices.removeAll()
        dices = Array(repeating: 1, count: diceCount)
        
        switch diceType {
        case 4:
            newDiceType = .fourSide
        case 6:
            newDiceType = .sixSide
        case 8:
            newDiceType = .eightSide
        case 10:
            newDiceType = .tenSide
        case 12:
            newDiceType = .twelveSide
        case 20:
            newDiceType = .twentySide
        case 100:
            newDiceType = .hundredSide
        default:
            newDiceType = .fourSide
        }
        
        self.diceType = newDiceType
        print(self.diceType)
    }
    
    func save() {
        do {
            let encodedResults = try JSONEncoder().encode(results)
            try encodedResults.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            
        }
    }
}
