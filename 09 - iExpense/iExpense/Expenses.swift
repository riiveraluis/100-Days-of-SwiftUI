//
//  Expenses.swift
//  iExpense
//
//  Created by Luis Rivera Rivera on 1/4/22.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    func delete(_ expense: ExpenseItem) {
        let index = items.firstIndex(of: expense)!
        items.remove(at: index)
    }
    
}
