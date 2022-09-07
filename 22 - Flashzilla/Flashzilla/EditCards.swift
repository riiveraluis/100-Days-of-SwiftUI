//
//  EditCards.swift
//  Flashzilla
//
//  Created by Luis Rivera Rivera on 6/21/22.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var cards: Cards
       @State private var newPrompt = ""
       @State private var newAnswer = ""

       var body: some View {
           NavigationView {
               List {
                   Section("Add new card") {
                       TextField("Prompt", text: $newPrompt)
                       TextField("Answer", text: $newAnswer)
                       Button("Add card", action: addCard)
                   }

                   Section {
                       ForEach(0..<cards.cards.count, id: \.self) { index in
                           VStack(alignment: .leading) {
                               Text(cards.cards[index].prompt)
                                   .font(.headline)
                               Text(cards.cards[index].answer)
                                   .foregroundColor(.secondary)
                           }
                       }
                       .onDelete(perform: removeCards)
                   }
               }
               .navigationTitle("Edit Cards")
               .toolbar {
                   Button("Done", action: done)
               }
               .listStyle(.grouped)
               .onAppear(perform: loadData)
           }
       }

    
    func done() {
        dismiss()
    }
    
    func addCard() {
            let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
            let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
            guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

            let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
            cards.insert(card, at: 0)
        newPrompt = ""
        newAnswer = ""
        }

        func removeCards(at offsets: IndexSet) {
            cards.remove(atOffsets: offsets)
        }
    
    func loadData() {
        cards.loadData()
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards(cards: Cards())
    }
}
