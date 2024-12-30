//
//  CategoryViewController.swift
//  Expense Tracker
//
//  Created by Celestial on 23/12/24.
//

import UIKit

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension CategoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExpenseCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        let category = ExpenseCategory.allCases[indexPath.row]
        cell.textLabel?.text = category.rawValue.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = navigationController?.viewControllers.first(where: { $0 is ViewController }) as? ViewController {
            viewController.searchBar.text = ExpenseCategory.allCases[indexPath.row].rawValue
            viewController.viewModel.isSearching = true
            viewController.viewModel.filteredExpense = viewController.viewModel.expense.filter {
                $0.category?.lowercased() == ExpenseCategory.allCases[indexPath.row].rawValue.lowercased()
            }
            viewController.tableView.reloadData()
        }
        
    }
    
    
    
}
