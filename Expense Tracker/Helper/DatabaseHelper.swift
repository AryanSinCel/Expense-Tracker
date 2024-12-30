//
//  DatabaseHelper.swift
//  Expense Tracker
//
//  Created by Celestial on 23/12/24.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    
    static var shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var title: String?
    var description: String?
    var amount: Double?
    var expenseDate: Date?
    var category: String?
    
    func save(object: [String: Any]) {
        let expense = NSEntityDescription.insertNewObject(forEntityName: Constant.entityName, into: context!) as! Expense
        
        if let titleString = object[Constant.entityTitle] as? String {
            title = titleString
        }
        if let descriptionString = object[Constant.entityDescription] as? String {
            description = descriptionString
        }
        if let doubleAmount = object[Constant.entityAmount] as? Double {
            amount = doubleAmount
        }
        if let expDate = object[Constant.entityDate] as? Date {
            expenseDate = expDate
        }
        if let cat = object[Constant.entityCategory] as? String {
            category = cat
        }
        
        expense.expenseTitle = title ?? "No Title"
        expense.expenseDesc = description ?? "No Description"
        expense.expenseAmount = amount ?? 0.0
        expense.expenseDate = expenseDate ?? Date()
        expense.category = category ?? "Uncategorized"
        
        do {
            print(title!,description!,amount ?? 0.0,expenseDate!,category!)
            try context?.save()
            print("Expense saved successfully")
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
        }
    }
    
    func getExpenseData()->[Expense]{
        var expense = [Expense]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.entityName)
        do{
            expense = try context?.fetch(fetchRequest) as! [Expense]
        }catch{
            print("Cannot get Data")
        }
        return expense
    }
    
    
    func deleteData(index:Int)->[Expense]{
        var expense = getExpenseData()
        context?.delete(expense[index])
        expense.remove(at: index)
        do{
            try context?.save()
        }catch{
            print("cannot delete data")
        }
        return expense
    }

    
    func editData(object:[String: Any], i:Int){
        
        let expense = getExpenseData()
        
        if let titleString = object[Constant.entityTitle] as? String {
            title = titleString
        }
        if let descriptionString = object[Constant.entityDescription] as? String {
            description = descriptionString
        }
        if let doubleAmount = object[Constant.entityAmount] as? Double {
            amount = doubleAmount
        }
        if let expDate = object[Constant.entityDate] as? Date {
            expenseDate = expDate
        }
        if let cat = object[Constant.entityCategory] as? String {
            category = cat
        }
        
        expense[i].expenseTitle = title ?? "No Title"
        expense[i].expenseDesc = description ?? "No Description"
        expense[i].expenseAmount = amount ?? 0.0
        expense[i].expenseDate = expenseDate ?? Date()
        expense[i].category = category ?? "Uncategorized"
        
        do{
            try context?.save()
        }catch{
            print("data is not updated")
        }
        
        
    }
}
