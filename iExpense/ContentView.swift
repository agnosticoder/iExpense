//
//  ContentView.swift
//  iExpense
//
//  Created by Satinder Singh on 27/11/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name:String
    let type:String
    let amount:Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let ecoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(ecoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter{ $0.type == "Personal"}
    }
    
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter{ $0.type == "Business"}
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(personalExpenses) { item in
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
                    .onDelete(perform: onDeletePersonalExpense)
                }
                
                Section("Business") {
                    ForEach(businessExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundColor(item.amount <= 10 ? .green : item.amount <= 100 ? .yellow : .red)
                        }
                    }
                    .onDelete(perform: onDeleteBusinessExpense)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItemGroup {
                    NavigationLink {
                        AddView(expenses: expenses)
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    EditButton()
                }
            }
        }
    }
    
    func onDeletePersonalExpense(at offsets: IndexSet) {
        for offset in offsets {
            if let index = expenses.items.firstIndex(where: {$0.id == personalExpenses[offset].id}) {
                expenses.items.remove(at: index)
            }
        }
    }
    
    func onDeleteBusinessExpense(at offsets: IndexSet) {
        for offset in offsets {
            if let index = expenses.items.firstIndex(where: {$0.id == businessExpenses[offset].id}) {
                expenses.items.remove(at: index)
            }
        }
    }
}

#Preview {
    ContentView()
}
