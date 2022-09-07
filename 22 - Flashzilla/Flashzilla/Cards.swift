//
//  Cards.swift
//  Flashzilla
//
//  Created by Luis Rivera Rivera on 6/21/22.
//

import Foundation

@MainActor class Cards: ObservableObject {
    @Published private(set) var cards: [Card]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("Cards")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            cards = [Card]()
        }
    }
    
    func add(_ card: Card) {
        cards.append(card)
        save()
    }
    
    func insert(_ card: Card, at index: Int) {
        cards.insert(card, at: index)
        save()
    }
    
    func remove(_ card: Card) {
        let indexOfCardToBeRemoved = cards.firstIndex(of: card)!
        cards.remove(at: indexOfCardToBeRemoved)
        save()
    }
    
    func remove(atOffsets: IndexSet) {
        cards.remove(atOffsets: atOffsets)
        save()
    }
    
    func removeFromDeck(_ index: Int) {
        cards.remove(at: index)
    }
    
    private func save() {
        do {
            let encodedCards = try JSONEncoder().encode(cards)
            try encodedCards.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save the cards.")
        }
    }
    
   func loadData() {
       do {
           let data = try Data(contentsOf: savePath)
           cards = try JSONDecoder().decode([Card].self, from: data)
       } catch {
           print("Could not load any cards.")
       }
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
