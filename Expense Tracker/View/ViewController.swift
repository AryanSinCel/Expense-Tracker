//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Celestial on 22/12/24.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryView: UIView!

    let viewModel = ViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = nil
        
        categoryView.isHidden = true
        viewModel.configure()
        searchBar.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
        tableView.reloadData()
    }


    
    @IBAction func selectCategory(_ sender: UIBarButtonItem) {
        if categoryView.isHidden{
            categoryView.isHidden = false
            tableView.alpha = 0.3
        }else{
            categoryView.isHidden = true
            tableView.alpha = 1.0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.updateExpenseIdentifier{
            let dvc = segue.destination as! DetailedViewController
            dvc.viewModel.updateDetail = viewModel.getFilterData()
            dvc.viewModel.isUpdating = false
            dvc.viewModel.cameFromSegue = true
            dvc.viewModel.index = viewModel.index
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = .black
            navigationItem.backBarButtonItem = backItem
        }
        
        if segue.identifier == Constant.addExpenseIdentifier{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = .black
            navigationItem.backBarButtonItem = backItem
        }
        
        if segue.identifier == Constant.showAnalyticIdentifier{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = .black
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath) as! ExpenseCell
        let expenseItem = viewModel.isSearching ? viewModel.filteredExpense[indexPath.row] : viewModel.expense[indexPath.row]
        cell.titleLabel.text = expenseItem.expenseTitle
        cell.descriptionLabel.text = expenseItem.expenseDesc
        cell.categoryLabel.text = expenseItem.category
        cell.amountLabel.text = Constant.currencyType+String(expenseItem.expenseAmount)
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let deletedIndex = viewModel.isSearching ? viewModel.filteredExpense[indexPath.row] : viewModel.expense[indexPath.row]
//            viewModel.expense = viewModel.deleteByIndex(deletedIndex: deletedIndex)
//            viewModel.filteredExpense = viewModel.expense.filter { $0.expenseTitle!.contains(searchBar.text ?? "") }
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let delete = UIContextualAction(style: .destructive, title: Constant.deleteString) { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            let deletedIndex = self.viewModel.isSearching ? self.viewModel.filteredExpense[indexPath.row] : self.viewModel.expense[indexPath.row]
            self.viewModel.expense = self.viewModel.deleteByIndex(deletedIndex: deletedIndex)
            self.viewModel.filteredExpense = self.viewModel.expense.filter { $0.expenseTitle!.contains(self.searchBar.text ?? "") }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }

         let rename = UIContextualAction(style: .normal, title: Constant.editString) { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            let vc = UIStoryboard.init(name: Constant.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.detailedViewController) as! DetailedViewController
            vc.viewModel.updateDetail = self.viewModel.getFilterData()
            vc.viewModel.isUpdating = true
            vc.viewModel.index = self.viewModel.index
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
            
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath.row)
        viewModel.index = indexPath.row
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.updateExpenseIdentifier, sender: self)
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 20
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}


extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.checkSearchedText(searchText:searchText,searchBar: searchBar)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching = false
        searchBar.text = ""
        viewModel.filteredExpense = viewModel.expense
        tableView.reloadData()
    }
    
}
