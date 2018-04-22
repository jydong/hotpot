//
//  PieViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/22/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import Charts

class PieViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    
    var foodDataEntry = PieChartDataEntry (value: 0)
    var transportDataEntry = PieChartDataEntry (value: 0)
    
    var entries = [PieChartDataEntry]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Access chart description
        pieChart.chartDescription?.text = ""
        
        foodDataEntry.value = 10
        foodDataEntry.label = "Food"
        
        transportDataEntry.value = 100
        transportDataEntry.label = "Transport"
        
        entries = [foodDataEntry, transportDataEntry]
        
        updateChartData()
    }
    
    func updateChartData(){
        let chartDataSet = PieChartDataSet(values: entries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        var colors: [UIColor] = []
        
        colors.append(UIColor.green)
        colors.append(UIColor.blue)
        
        chartDataSet.colors = colors
            
        pieChart.data = chartData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
