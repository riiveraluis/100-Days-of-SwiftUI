//
//  ContentView.swift
//  iExpense
//
//  Created by Luis Rivera Rivera on 1/3/22.
//

import SwiftUI

struct ExpenseCategory: Identifiable {
    let name: String
    let expenses: [ExpenseItem]
    let id = UUID()
}

struct ContentView: View {
    
    @StateObject var expenses = Expenses()
    @State private var showingAddExpensive = false
    
    var currencyMode: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    
    var categorizedExpenses: [ExpenseCategory] {
        return [ExpenseCategory(name: "Personal", expenses: personalExpenses),
                ExpenseCategory(name: "Business", expenses: businessExpenses)
        ]
    }
    
    // Auxiliary code
    var amountColor: SwiftUI.Color = .black
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categorizedExpenses) { category in
                    Section(header: Text("\(category.name)")) {
                        ForEach(category.expenses) { item in
                            Group {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    if item.amount <= 10.0 {
                                        Text(item.amount,format: currencyMode)
                                            .foregroundColor(SwiftUI.Color.green)
                                    } else if item.amount < 100.0 {
                                        Text(item.amount,format: currencyMode)
                                            .foregroundColor(SwiftUI.Color.yellow)
                                    } else {
                                        Text(item.amount,format: currencyMode)
                                            .foregroundColor(SwiftUI.Color.red)
                                    }
                                }
                                .swipeActions {
                                    Button {
                                        expenses.delete(item)
                                    } label: {
                                        Label("Remove Expense", systemImage: "trash")
                                    }
                                }
                                .accessibilityLabel("\(item.name) costing \(item.amount) \(item.amount > 1.00 ? "dollars" : "dollar")")
                                .accessibilityHint(item.type)
                            }
                        }
                    }
                }
            }.navigationTitle("iExpenses")
                .toolbar {
                    Button {
                        showingAddExpensive = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showingAddExpensive) {
                    AddView(expenses: expenses)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
