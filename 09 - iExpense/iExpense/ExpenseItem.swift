//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Luis Rivera Rivera on 1/4/22.
//

import Foundation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
    static func == (lhs: ExpenseItem, rhs: ExpenseItem) -> Bool {
        lhs.id == rhs.id
    }
}
