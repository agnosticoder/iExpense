//
//  ExpensesView.swift
//  iExpense
//
//  Created by Satinder Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    var body: some View {
        ForEach(expenses) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    
                    Text(item.type)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .foregroundColor(item.amount <= 10 ? .green : item.amount <= 100 ? .yellow : .red)
                    .font(.body)
            }
        }
        .onDelete(perform: onDeleteExpense)
    }
    
    init(sortBy: [SortDescriptor<ExpenseItem>], filter: String){
        _expenses = Query(filter: #Predicate<ExpenseItem> { expense in
            filter == "All" ? true : expense.type == filter
        }, sort: sortBy)
    }
    
    func onDeleteExpense(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ExpenseItem.self, configurations: config)
    
    let expenses = [
        ExpenseItem(name: "Expense 1", type: "Personal", amount: 714.94),
        ExpenseItem(name: "Expense 2", type: "Business", amount: 429.09),
        ExpenseItem(name: "Expense 3", type: "Personal", amount: 459.40),
        ExpenseItem(name: "Expense 4", type: "Business", amount: 900.78),
        ExpenseItem(name: "Expense 5", type: "Personal", amount: 732.06),
        ExpenseItem(name: "Expense 6", type: "Business", amount: 382.48),
        ExpenseItem(name: "Expense 7", type: "Personal", amount: 126.82),
        ExpenseItem(name: "Expense 8", type: "Business", amount: 825.44),
        ExpenseItem(name: "Expense 9", type: "Personal", amount: 351.16),
        ExpenseItem(name: "Expense 10", type: "Business", amount: 403.62),
        ExpenseItem(name: "Expense 49", type: "Personal", amount: 265.46),
        ExpenseItem(name: "Expense 50", type: "Business", amount: 228.60)
    ]
    
    for expense in expenses {
        container.mainContext.insert(expense)
    }
    
    return ExpensesView(sortBy: [SortDescriptor(\ExpenseItem.name)], filter: "All")
        .modelContainer(container)
}
