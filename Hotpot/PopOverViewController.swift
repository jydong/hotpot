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
class PopOverViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
   
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var pickviewCur: UIPickerView!
    
    @IBOutlet weak var pickviewCat: UIPickerView!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var noteField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let currency = ["USD", "CAD", "CNY", "EUR", "GBP", "JPY"]
    let category = ["Food", "Housing", "Transport", "Shopping", "Health", "Travel", "Bills", "Investments", "Income"]
    
    var selectedCur = "USD"
    var selectedCat = "Food"
    var imageFilePath = ""
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
    
    // touch on the screen will hide the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberField.resignFirstResponder()
         noteField.resignFirstResponder()
    }


    @IBAction func openCameraButton(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera;
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("image picker controller")
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
//        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
//            print("if let")
//            let imgName = imgUrl.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//            let localPath = documentDirectory?.appending(imgName)
//
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let data = UIImagePNGRepresentation(image)! as NSData
//            data.write(toFile: localPath!, atomically: true)
//            //let imageData = NSData(contentsOfFile: localPath!)!
//            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
//            print(photoURL)
//        }
        
//        if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
//            print(imageURL)
//        }
        
        
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    
    func SaveImageInDD(_ name: String){
        if let image = imagePicked.image {
            let fileManager = FileManager.default
            let n = name+".jpg"
            let pathName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString).appendingPathComponent(n)
            //let image = imagePicked.image
            let imagedata = UIImageJPEGRepresentation(image, 0.5)
            fileManager.createFile(atPath: pathName, contents: imagedata, attributes: nil)
            print(pathName)
        }
        else{
            print("image is nil")
        }
    }
    
    func getDirectoryPath()-> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let doc = path[0]
        return doc
    }
//    
//    func GetImage(_ name: String){
//        let fileManager = FileManager.default
//        let path = (self.getDirectoryPath() as NSString).appendingPathComponent(name+".jpg")
//        if fileManager.fileExists(atPath: path){
//            imageView = UIImage(contentsOfFile: path)
//        }
//        else{
//            print("No Image")
//        }
//    }
    
    // save popup
    @IBAction func savePopup(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entry = Entry(context: context) // Link Entry & Context
        
        if Double(numberField.text!) != nil{
            entry.amount = numberField.text!
        }
        else{
            entry.amount = "0.00"
            print("cannot convert textfield input to type double")
        }

        entry.category = selectedCat.lowercased()
        entry.currency = selectedCur
        entry.note = noteField.text!
        
        let now = NSDate()
        let dateFormatter = DateFormatter()

        entry.date = now as Date
        
        dateFormatter.dateFormat = "M"
        let current_month = Int(dateFormatter.string(from:now as Date))
        
        dateFormatter.dateFormat = "y"
        let current_year = Int(dateFormatter.string(from:now as Date))
            
        
        getBudgetData()
        var new_month = true
        var reach_budget = false
        var current_budget = 0.0
        
        for b in budgets {
            let m: Int = Int(b.month)
            let y: Int = Int(b.year)
            if (m == current_month!) && (y == current_year!){
                new_month = false
                if let a = entry.amount {
                    
                    var num = Double(a)!
                    
                    
                    // convert amount to USD 
                    if entry.currency == "CAD" {
                        num = 0.78 * num
                    }
                    else if entry.currency == "CNY" {
                        num = 0.16 * num
                    }
                    else if entry.currency == "JPY" {
                        num = 0.0093 * num
                    }
                    else if entry.currency == "EUR" {
                        num = 1.23 * num
                    }
                    else if entry.currency == "GBP" {
                        num = 1.4 * num
                    }
                    else {}
            
    
                    
                    // update category sum
                    let category = entry.category!
                    
                    // update sum
                    if category != "income" {
                        b.sum += num
                    }
                    
                    
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
                        case "income":
                            b.income += num
                        default:
                            print("invalid category")
                    }
                    // check if the budget of the current month is reached
                    if b.sum >= b.budget {
                        reach_budget = true
                        current_budget = b.budget
                    }
                    
                    break
                }
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
            b.income = 0.0
            
            // convert amount to USD
            if let a = entry.amount {
                var num = Double(a)!
                
                if entry.currency == "CAD" {
                    num = 0.78 * num
                }
                else if entry.currency == "CNY" {
                    num = 0.16 * num
                }
                else if entry.currency == "JPY" {
                    num = 0.0093 * num
                }
                else if entry.currency == "EUR" {
                    num = 1.23 * num
                }
                else if entry.currency == "GBP" {
                    num = 1.4 * num
                }
                else {}

                
                let category = entry.category!
                
                // update sum
                if category != "income" {
                    b.sum += num
                }
                
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
                    case "income":
                        b.income += num
                    default:
                        print("invalid category")
                }
                // check if the budget of the current month is reached
                if b.sum >= b.budget {
                    reach_budget = true
                    current_budget = b.budget
                }
            }
        }
        
        if(entry.date != nil){
            if(imagePicked != nil){
                let name = entry.date!
                SaveImageInDD(String(describing: name))
            }
        }
        
        

        
        // save data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // display a pop up alert box if budget is reached
        if reach_budget {
            createAlert(title: "You've reached your monthly budget: \(String(format: "%.2f", current_budget)) USD", message: "Change your budget?")
        }
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // close PopUp and return to the last viewcontroller
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
    
    //pop up a alert screen
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)

            //go to BudgetViewController through ccurrent visible controller
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BudgetViewController")
            UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
            
            
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("NO")
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        //self.present(alert, animated: true, completion: nil)
    }
}

// hide keyboard and return typed data
extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// find the topViewController on your UIApplication Stack, and from there present your controller
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


