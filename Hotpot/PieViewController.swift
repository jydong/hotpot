//
//  PieViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/22/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

//This file will display a new window showing the pie charts for monthly expenses by categories.

import UIKit
import Charts
import CoreData

class PieViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selected_budget:[Budget] = []

    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var chartTitle: UILabel!
    @IBOutlet weak var currentBudget: UILabel!
    @IBOutlet weak var currentSum: UILabel!
    
    //init the pie chart data entries
    var foodDataEntry = PieChartDataEntry (value: 0)
    var transportDataEntry = PieChartDataEntry (value: 0)
    var housingDataEntry = PieChartDataEntry (value: 0)
    var shoppingDataEntry = PieChartDataEntry (value: 0)
    var healthDataEntry = PieChartDataEntry (value: 0)
    var billsDataEntry = PieChartDataEntry (value: 0)
    var investmentsDataEntry = PieChartDataEntry (value: 0)
    var travelDataEntry = PieChartDataEntry (value: 0)
    
    var entries = [PieChartDataEntry]()
    
    
    var selected_month: String = "April"
    var selected_month_int: Int = 4
    var selected_year: Int = 2018
    
    
    //This function will be called once the page is loaded
    //The pie chart will be displayed immediately
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let now = NSDate()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM"
        selected_month = dateFormatter.string(from:now as Date)
        
        dateFormatter.dateFormat = "M"
        let selected_month_int = Int(dateFormatter.string(from:now as Date))
        
        dateFormatter.dateFormat = "y"
        
        let selected_year = Int(dateFormatter.string(from:now as Date))

        getSelectedBudget(month:selected_month_int!, year:selected_year!)
        
        // Access chart description
        if selected_year != nil {
            pieChart.chartDescription?.text = "Report for \(selected_month) \(selected_year!)"
            chartTitle.font = UIFont.boldSystemFont(ofSize:23.0)
            chartTitle.text = "Report for \(selected_month) \(selected_year!)\nMonthly budget: \(selected_budget[0])"
            currentBudget.text = "Budget: \(String(format: "%.2f",selected_budget[0].budget)) USD"
            currentSum.text = "Total spending: \(String(format: "%.2f",selected_budget[0].sum)) USD"
        }
        else{
            pieChart.chartDescription?.text = "Report for \(selected_month) 2018"
            chartTitle.font = UIFont.boldSystemFont(ofSize:23.0)
            chartTitle.text = "Report for \(selected_month) 2018 \nMonthly budget: \(selected_budget[0])"
            currentBudget.text = "Budget: \(String(format: "%.2f",selected_budget[0].budget)) USD"
            currentSum.text = "Total spending: \(String(format: "%.2f",selected_budget[0].sum)) USD"
        }
        
        //set the pie chart data entry values and labels
        foodDataEntry.value = selected_budget[0].food
        foodDataEntry.label = "Food"
        
        transportDataEntry.value = selected_budget[0].transport
        transportDataEntry.label = "Transport"
    
        housingDataEntry.value = selected_budget[0].housing
        housingDataEntry.label = "Housing"
        
        healthDataEntry.value = selected_budget[0].health
        healthDataEntry.label = "Health"
        
        shoppingDataEntry.value = selected_budget[0].shopping
        shoppingDataEntry.label = "Shopping"
        
        billsDataEntry.value = selected_budget[0].bills
        billsDataEntry.label = "Bills"
        
        investmentsDataEntry.value = selected_budget[0].investments
        investmentsDataEntry.label = "Investments"
        
        travelDataEntry.value = selected_budget[0].travel
        travelDataEntry.label = "travel"
        
        //add entries to the entry list
        entries = [foodDataEntry, transportDataEntry, housingDataEntry, healthDataEntry, shoppingDataEntry,
                    billsDataEntry, investmentsDataEntry, travelDataEntry]
        
        //call updateChartData to get the most recent results and update the chart
        updateChartData()
    }
    
    //This function sets the colors of pie chart data entries and assigns the data to our pie chart
    func updateChartData(){
        let chartDataSet = PieChartDataSet(values: entries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        var colors: [UIColor] = []
        colors.append(UIColor(red: 1, green: 165/255, blue: 0, alpha: 1))
        colors.append(UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1))
        colors.append(UIColor(red: 0.3, green: 0.4, blue: 0.9, alpha: 1))
        colors.append(UIColor(red: 0.4, green: 0.3, blue: 0.5, alpha: 1))
        colors.append(UIColor(red: 0.6, green: 0.4, blue: 0.5, alpha: 1))
        colors.append(UIColor(red: 0.9, green: 0.6, blue: 0.7, alpha: 1))
        colors.append(UIColor(red: 0.9, green: 0.8, blue: 0, alpha: 1))
        colors.append(UIColor(red: 0.4, green: 0.3, blue: 0, alpha: 1))
        
        
        chartDataSet.colors = colors
            
        pieChart.data = chartData
    }
    
    //make sure the controller receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get the current budget
    func getSelectedBudget(month:Int, year:Int){
        do {
            let budgets:[Budget]  = try context.fetch(Budget.fetchRequest())
            for b in budgets {
                let m: Int = Int(b.month)
                let y: Int = Int(b.year)
                if (m == month) && (y == year){
                    selected_budget.append(b)
                    break
                }
            }
        }
        catch {
            print("Fetching Selected Budget Failed")
        }
    }
    
    // Go back to the previous page
    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
