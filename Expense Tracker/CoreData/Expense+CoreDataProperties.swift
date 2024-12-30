//
//  Expense+CoreDataProperties.swift
//  Expense Tracker
//
//  Created by Celestial on 23/12/24.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: Constant.entityName)
    }

    @NSManaged public var category: String?
    @NSManaged public var expenseAmount: Double
    @NSManaged public var expenseDate: Date?
    @NSManaged public var expenseDesc: String?
    @NSManaged public var expenseTitle: String?

}

extension Expense : Identifiable {

}
