//
//  AddView.swift
//  iExpense
//
//  Created by Satinder Singh on 28/11/24.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var expense:ExpenseItem
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        Form {
            TextField("Name", text: $expense.name)
            
            Picker("Type", selection: $expense.type) {
                ForEach(types, id: \.self) {
                    Text($0).tag($0)
                }
            }
            
            TextField("Amount", value: $expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
                .navigationTitle("Add New Expense")
                        .toolbar {
                            ToolbarItem(placement: .automatic) {
                                Button("Save") {
                                    dismiss()
                                }
                            }
                            ToolbarItem(placement: .destructiveAction){
                                Button("Dismiss", role: .destructive) {
                                    dismiss()
                                    modelContext.delete(expense)
                                }
                                .foregroundStyle(.red)
                            }
                        }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AddView(expense: ExpenseItem(name: "Book", type: "Personal", amount: 30))
}
