//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Satinder Singh on 17/12/24.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var name:String
    var type:String
    var amount:Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
