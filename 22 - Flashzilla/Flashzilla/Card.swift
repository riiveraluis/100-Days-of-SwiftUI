//
//  Card.swift
//  Flashzilla
//
//  Created by Luis Rivera Rivera on 6/20/22.
//

import Foundation

struct Card: Codable, Identifiable, Equatable {
    var id = UUID() 
    
    let prompt: String
    let answer: String
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = Card(prompt: "Who is the best company on the world?", answer: "Apple")
}
