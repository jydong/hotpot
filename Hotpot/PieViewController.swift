//
//  PieViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/22/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import Charts
import CoreData

class PieViewController: UIViewController {
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selected_budget:[Budget] = []

    @IBOutlet weak var pieChart: PieChartView!
    
    let chartTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
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
            chartTitle.text = "Report for \(selected_month) \(selected_year!)\nMonthly budget: \(selected_budget[0])"
        }
        else{
            pieChart.chartDescription?.text = "Report for \(selected_month) 2018"
            chartTitle.text = "Report for \(selected_month) 2018 \nMonthly budget: \(selected_budget[0])"
        }
        
        
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
        

        entries = [foodDataEntry, transportDataEntry, housingDataEntry, healthDataEntry, shoppingDataEntry,
                    billsDataEntry, investmentsDataEntry, travelDataEntry]
        
        updateChartData()
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    // Go back
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
