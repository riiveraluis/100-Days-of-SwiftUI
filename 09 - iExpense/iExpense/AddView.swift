//
//  AddView.swift
//  iExpense
//
//  Created by Luis Rivera Rivera on 1/5/22.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @State private var errorMessageBody = ""
    @State private var isErrorShowing = false
    
    var types = ["Personal", "Business"]
    
    var currencyMode: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: currencyMode)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    guard amount > 0.0 else {
                        errorMessageBody = "Please enter a valid expense cost."
                        isErrorShowing.toggle()
                        return
                    }
                    
                    guard name != "" else {
                        errorMessageBody = "Please enter a valid expense name."
                        isErrorShowing.toggle()
                        return
                    }
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
        .alert("Error", isPresented: $isErrorShowing) {
        } message: {
            Text("Please enter a valid expense cost.")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
