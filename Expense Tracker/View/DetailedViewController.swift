//
//  DetailedViewController.swift
//  Expense Tracker
//
//  Created by Celestial on 23/12/24.
//

import UIKit
import FSCalendar


class DetailedViewController: UIViewController, FSCalendarDataSource {
    
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    
    let viewModel = DetailedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderView.delegate = self
        calenderView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        categoriesView.isHidden = true
        
        if let detail = viewModel.updateDetail {
            titleTextField.text = detail.expenseTitle
            descriptionTextField.text = detail.expenseDesc
            categoryLabel.text = detail.category
            amountTextField.text = "\(detail.expenseAmount)"
            if let expenseDate = detail.expenseDate {
                calenderView.select(expenseDate)
                viewModel.fsDate = expenseDate
            }
        }
        
        updateSaveButtonTitle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSaveButtonTitle()
    }
    
    func updateSaveButtonTitle(){
        if viewModel.cameFromSegue{
            saveBtn.isHidden = true
            deleteBtn.isHidden = true
        }else{
            saveBtn.title = viewModel.getButtonTitle()
        }
      
    }
    
    @IBAction func deleteExpense(_ sender: UIBarButtonItem) {
        print("Delete expense logic here")
        
        viewModel.delete()
        pop()
    }
    
    @IBAction func saveExpense(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let amountText = amountTextField.text, let amount = Double(amountText),
              let category = categoryLabel.text, !category.isEmpty else {
            print("All fields are required")
            return
        }
        
        let dict: [String: Any] = [
            Constant.entityTitle: title,
            Constant.entityDescription: description,
            Constant.entityAmount: amount,
            Constant.entityDate: viewModel.fsDate,
            Constant.entityCategory: category
        ]
        
        if viewModel.isUpdating {
            print("Update logic here")
            viewModel.edit(dict: dict)
            pop()
            
        } else {
            viewModel.save(dict: dict)
            pop()
        }
    }
    
    func pop(){
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func showCategories(_ sender: UIButton) {
        categoriesView.isHidden.toggle()
    }
}

extension DetailedViewController: UITableViewDelegate, UITableViewDataSource {
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
        let selectedCategory = ExpenseCategory.allCases[indexPath.row]
        categoryLabel.text = selectedCategory.rawValue.capitalized
        categoriesView.isHidden = true
    }
}

extension DetailedViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.dateFormat
        viewModel.fsDate = date
        print("Selected date: \(dateFormatter.string(from: date))")
    }
}
