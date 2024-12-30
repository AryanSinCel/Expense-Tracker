//
//  AnalyticViewController.swift
//  Expense Tracker
//
//  Created by Celestial on 24/12/24.
//

import UIKit
import Charts

class AnalyticViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var pieChartView: UIView!
    
    let viewModel = AnalyticViewModel()
    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        pieChart.frame = CGRect(x: 0, y: 0, width: pieChartView.frame.size.width * 2 , height: pieChartView.frame.size.height * 2)
        pieChart.center = CGPoint(x: pieChartView.frame.size.width / 2, y: pieChartView.frame.size.height / 2)
        pieChartView.addSubview(pieChart)
        
        viewModel.getData()
        viewModel.configureAnalytic()
        
        totalLabel.text = String(format: Constant.expenseFormat, viewModel.total)
        
        print("Fetched Expenses: \(viewModel.analyticExpense)")
        print("Category Totals: \(viewModel.categoryTotal)")
        
        updatePieChart()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
}

extension AnalyticViewController: ChartViewDelegate{
    func updatePieChart() {
        var entries: [PieChartDataEntry] = []
        
        for (category, total) in viewModel.categoryTotal {
            let entry = PieChartDataEntry(value: total, label: category)
            entries.append(entry)
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "Category Breakdown")
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.sliceSpace = 2.0
        dataSet.valueTextColor = .black
        dataSet.valueFont = .systemFont(ofSize: 12)
        
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DefaultValueFormatter(decimals: 2))
        
        pieChart.data = data
        pieChart.holeColor = .clear
        pieChart.chartDescription.text = "Expense Breakdown"
        pieChart.notifyDataSetChanged()
    }
    
}

extension AnalyticViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        
        let category = viewModel.categoryKeys[indexPath.row]
        let total = viewModel.categoryTotal[category] ?? 0.0
        
        cell.textLabel?.text = category
        cell.detailTextLabel?.text = String(format: Constant.expenseFormat, total)
        
        return cell
    }
}
