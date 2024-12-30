//
//  ViewModel.swift
//  Expense Tracker
//
//  Created by Celestial on 24/12/24.
//

import Foundation
import UIKit

class ViewModel{
    
    var expense = [Expense]()
    var filteredExpense = [Expense]()
    var isSearching = false
    var index:Int = 0
    
    func configure(){
        getData()
        filteredExpense = expense
    }
    
    func getData(){
        expense = DatabaseHelper.shareInstance.getExpenseData()
    }
    
    func getDataCount()->Int{
        return isSearching ? filteredExpense.count : expense.count
    }
    
    func getFilterData() -> Expense{
        return isSearching ? filteredExpense[index] : expense[index]
    }
    
    func deleteByIndex(deletedIndex:Expense)->[Expense]{
        return DatabaseHelper.shareInstance.deleteData(index: expense.firstIndex(where: { $0 == deletedIndex })!)
    }
    
    func getFilteredExpense(searchBar:UISearchBar,searchText:String)->[Expense]{
        return expense.filter{
            $0.expenseTitle!.lowercased().contains(searchText.lowercased()) ||
            $0.category!.lowercased().contains(searchText.lowercased())
        }
    }
    
    func checkSearchedText(searchText:String,searchBar:UISearchBar){
        if searchText.isEmpty{
            isSearching = false
            filteredExpense = expense
        }else{
            isSearching = true
            filteredExpense = getFilteredExpense(searchBar:searchBar,searchText:searchText)
        }
    }
}
