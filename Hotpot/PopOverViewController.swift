//
//  PopOverViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 3/18/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

// This file will display a popover page where the user can enter a new record of expense. The inputs include the amount of expense, currency type, category, and additional comments.

import UIKit
import CoreData
class PopOverViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var pickviewCur: UIPickerView!
    
    @IBOutlet weak var pickviewCat: UIPickerView!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var noteField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let currency = ["USD", "CAD", "CNY", "EUR", "GBP", "JPY"]
    let category = ["Food", "Housing", "Transport", "Shopping", "Health", "Travel", "Bills", "Investments"]
    
    var selectedCur = "USD"
    var selectedCat = "Food"
    
    var budgets:[Budget] = []
    
    
    //return the number of components based on the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickviewCur{
            return 1
        }
        else if pickerView == pickviewCat{
            return 1
        }
        return 0
    }
    
    //return the contents of the selected row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickviewCur{
            return currency[row]
        }
        else if pickerView == pickviewCat{
            return category[row]
        }
        return ""
    }
    
    //return the length of the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickviewCur{
            return currency.count
        }
        else if pickerView == pickviewCat{
            return category.count
        }
        return 0
    }
    
    //set the label to the value that is gotten from the pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickviewCur{
            label.text = currency[row]
            selectedCur = currency[row]
        }
        else if pickerView == pickviewCat{
            label2.text = category[row]
            selectedCat = category[row]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //touch on the screen will hide the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberField.resignFirstResponder()
         noteField.resignFirstResponder()
        
    }

    
    // save popup
    @IBAction func savePopup(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entry = Entry(context: context) // Link Entry & Context
        
        if let amount = Double(numberField.text!){
            entry.amount = numberField.text!
        }
        else{
            entry.amount = "0.00"
            print("cannot convert textfield input to type double")
        }

        entry.category = selectedCat
        entry.currency = selectedCur
        entry.note = noteField.text!
        
        let now = NSDate()
        let dateFormatter = DateFormatter()
        
//        dateFormatter.dateFormat = "MMM dd, yyyy"
//        let current_date = dateFormatter.string(from:now as Date)
        entry.date = now as Date
        
        dateFormatter.dateFormat = "M"
        let current_month = Int(dateFormatter.string(from:now as Date))
        

        dateFormatter.dateFormat = "y"
        let current_year = Int(dateFormatter.string(from:now as Date))
            
        
        getBudgetData()
        var new_month = true
        for b in budgets {
            let m: Int = Int(b.month)
            let y: Int = Int(b.year)
            if (m == current_month!) && (y == current_year!){
                if let a = entry.amount {
                    let num = Double(a)!
                    //b.sum = 0.0
                    b.sum += num
                    let category = entry.category!.lowercased()
                    print(category)
                    switch category {
                        case "food":
                            b.food += num
                        case "housing":
                            b.housing += num
                        case "transport":
                            b.transport += num
                        case "travel":
                            b.travel += num
                        case "bills":
                            b.bills += num
                        case "investments":
                            b.investments += num
                        case "shopping":
                            b.shopping += num
                        case "health":
                            b.health += num
                        default:
                            break
                    }
                    
                }
                new_month = false
                break
                
            }
        }
        
        if new_month {
            let b = Budget(context: context) // Link Budget & Context
            b.budget = 1000.0
            b.sum = 0.0
            b.month = Int16(current_month!)
            b.year = Int16(current_year!)
            b.food = 0.0
            b.housing = 0.0
            b.transport = 0.0
            b.travel = 0.0
            b.bills = 0.0
            b.investments = 0.0
            b.shopping = 0.0
            b.health = 0.0
            
            if let a = entry.amount {
                let num = Double(a)!
                b.sum += num
                let category = entry.category!.lowercased()
                switch category {
                    case "food":
                        b.food += num
                    case "housing":
                        b.housing += num
                    case "transport":
                        b.transport += num
                    case "travel":
                        b.travel += num
                    case "bills":
                        b.bills += num
                    case "investments":
                        b.investments += num
                    case "shopping":
                        b.shopping += num
                    case "health":
                        b.health += num
                    default:
                        break
                }
            }
        }
        
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


