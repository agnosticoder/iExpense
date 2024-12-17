//
//  ContentView.swift
//  iExpense
//
//  Created by Satinder Singh on 27/11/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    @State private var sortBy = [SortDescriptor(\ExpenseItem.name)]
    @State private var filterBy = "All"
    @State private var path = [ExpenseItem]()
    
    let filters: Set<String> = ["All", "Personal", "Business"]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ExpensesView(sortBy: sortBy, filter: filterBy)
            }
            .navigationTitle("iExpense")
            .navigationDestination(for: ExpenseItem.self) { expense in
                AddView(expense: expense)
            }
            .toolbar {
                ToolbarItemGroup {
                    Button("Add Expense", systemImage: "plus") {
                        let expense = ExpenseItem(name: "", type: "Personal", amount: 0)
                        
                        modelContext.insert(expense)
                        
                        path = [expense]
                    }
                    
                    Menu("Sort by", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort by", selection: $sortBy) {
                            Text("Name").tag([SortDescriptor(\ExpenseItem.name)])
                            Text("Amount").tag([SortDescriptor(\ExpenseItem.amount)])
                        }
                    }
                    
                    Menu("Filter by", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter", selection: $filterBy) {
                            ForEach(Array(filters), id: \.self) { filter in
                                Text(filter)
                            }
                        }
                    }

                    EditButton()
                }
                
                
            }
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
    
    return ContentView()
        .modelContainer(container)
}
