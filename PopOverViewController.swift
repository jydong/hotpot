//
//  PopOverViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 3/18/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

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
    
    let currency = ["USD", "CAD", "CNY", "EUR", "GBP", "JPY"]
    let category = ["Food", "Housing", "Transport", "Medical"]
    
    var selectedCur = "USD"
    var selectedCat = "Food"
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickviewCur{
            return 1
        }
        else if pickerView == pickviewCat{
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickviewCur{
            return currency[row]
        }
        else if pickerView == pickviewCat{
            return category[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickviewCur{
            return currency.count
        }
        else if pickerView == pickviewCat{
            return category.count
        }
        return 0
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberField.resignFirstResponder()
         noteField.resignFirstResponder()
        
    }

    
    // save popup
    @IBAction func savePopup(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entry = Entry(context: context) // Link Entry & Context
        entry.amount = numberField.text!
        entry.category = selectedCat
        entry.currency = selectedCur
        entry.note = noteField.text!
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


