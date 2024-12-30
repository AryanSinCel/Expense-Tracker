//
//  AnalyticViewModel.swift
//  Expense Tracker
//
//  Created by Celestial on 24/12/24.
//

import Foundation

class AnalyticViewModel{
    
    var analyticExpense = [Expense]()
    var categoryTotal: [String: Double] = [:]
    var categoryKeys: [String] = []
    var total = 0.0
    
    func getData(){
        analyticExpense = DatabaseHelper.shareInstance.getExpenseData()
    }
    
    func configureAnalytic(){
        
        for expense in analyticExpense {
            total += Double(expense.expenseAmount)
            
            if let category = expense.category {
                categoryTotal[category, default: 0.0] += Double(expense.expenseAmount)
            } else {
                print("Expense category is nil for expense: \(expense)")
            }
        }

        categoryKeys = Array(categoryTotal.keys).sorted()
    }
    
    func getCount() -> Int{
        return categoryTotal.count
    }
    
}
