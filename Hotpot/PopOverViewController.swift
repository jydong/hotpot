//  The pop over view showing up after the user pressing the + button on the main view. Allows user to select currency, category and acts as an intermediate
//  view toward the addnote view.(Press addnote and direct the user to the addnote view)
//  PopOverViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 3/18/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var Popupview: UIView!
    //currency display
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var numberField: UITextField!
    //currency picker
    @IBOutlet weak var pickviewCur: UIPickerView!
    //category picker
    @IBOutlet weak var pickviewCat: UIPickerView!
    //categoty display
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var noteField: UITextField!
    //Possible choices of currency and category for the pickviewers
    let currency = ["USD", "CAD", "CNY", "EUR", "GBP", "JPY"]
    let category = ["Food", "Housing", "Transport", "Medical"]
    //The number of possible selection at anytime is 1.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickviewCur{
            return 1
        }
        else if pickerView == pickviewCat{
            return 1
        }
        return 0
    }
    //return the selected item from the pickerview.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickviewCur{
            return currency[row]
        }
        else if pickerView == pickviewCat{
            return category[row]
        }
        return ""
    }
    //return the count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickviewCur{
            return currency.count
        }
        else if pickerView == pickviewCat{
            return category.count
        }
        return 0
    }
    //display the selected items from pickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickviewCur{
            label.text = currency[row]
        }
        else if pickerView == pickviewCat{
            label2.text = category[row]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberField.resignFirstResponder()
         noteField.resignFirstResponder()
        
    }
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
//resolve focus issues, get rid of the keyboard after focus is gone
extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


