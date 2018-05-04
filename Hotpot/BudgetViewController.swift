//
//  BudgetViewController.swift
//  Hotpot
//
//  Created by Jingyan Dong on 4/25/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController {

    @IBOutlet weak var budgetTextField: UITextField!
    var budgets:[Budget] = []
    
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
   //save to database
    @IBAction func setBudget(_ sender: Any) {
       
        getBudgetData()

        for b in budgets{
            let m: Int = Int(b.month)
            let y: Int = Int(b.year)
            if (m == 5) && (y == 2018){
                if (budgetTextField.text != nil){
                    if Double(budgetTextField.text!) != nil{
                        b.budget = Double(budgetTextField.text!)!
                        print(b.budget)
                    }
                    else{
                        print("cannot convert textfield input to type double")
                    }
                }
            
            }
        }
    }
    
    // fetch budget data
    func getBudgetData() {
        do {
            budgets = try context.fetch(Budget.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
