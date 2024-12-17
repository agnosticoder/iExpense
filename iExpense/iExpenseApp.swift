//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Satinder Singh on 27/11/24.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
