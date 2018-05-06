//
//  ViewController.swift
//  Hotpot
//
//  Created by Jingyan Dong on 4/2/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

//This file will display the main page of the application, with a sidebar botton and a add botton on the nevigation bar and a table of history records. New records added will be appended to the end of the botton. A cell can also be deleted from the table.

import UIKit
import CoreData



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var testImage: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // store an array of entries
    var entries:[Entry] = []

    var budgets:[Budget] = []
    
    
    // this function will be called when the page is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        // display slider menu page
        sideMenus()
        


    }
    
    // this function is sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // create a slider menu
    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
 
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //Notifies the view controller that its view is about to be added to a view hierarchy
    override func viewWillAppear(_ animated: Bool) {
        getData()
        getBudgetData()
        print("budget count: \(budgets.count)")
        tableView.reloadData()
        
        for b in budgets {
            print(b)
            
//            if(b.month != 4){
//                context.delete(b)
//                (UIApplication.shared.delegate as! AppDelegate).saveContext()
//            }
            print("hi")
            
        }
        
        if(entries != []){
        
            if(entries.last!.date != nil){
                let name = entries.last!.date!
                //testImage.image = UIImage(named: "background.jpg")
                getImage(String(describing:(name)))
            }
            else{
                testImage.image = UIImage(named: "background.jpg")
            }
        }
        else{
            testImage.image = UIImage(named: "background.jpg")
        }
        
        
    }
    
    func getDirectoryPath()-> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let doc = path[0]
        return doc
    }
    
    func getImage(_ name: String){
        let fileManager = FileManager.default
        print(name + ".jpg")
        let path = (self.getDirectoryPath() as NSString).appendingPathComponent(name + ".jpg")
        if fileManager.fileExists(atPath: path){
            if(testImage == nil){
                print("test image is nil")
            }
            testImage.image = UIImage(contentsOfFile: path)
        }
        else{
            print("No Image")
            testImage.image = UIImage(named: "background.jpg")
        }
    }

    // get tableView cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
        //return budgets.count
    }

    // display tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        // display entries in reverse order so that the newest entries are displayed on top
        let entry = entries.reversed()[indexPath.row]
        
        
        var displayedString = ""
        var emoji = "🍔"
        
        
        if let cur = entry.currency {
            displayedString = "\("      ")\(cur)"
        }

        if let a = entry.amount{
            displayedString = "\(displayedString)\(" ")\(a)"
        }

        if let cat = entry.category {
            if entry.category == "food" {
                emoji = "🍔"
            }
            else if entry.category == "housing" {
                emoji = "🏠"
            }
            else if entry.category == "transport" {
                emoji = "🚗"
            }
            else if entry.category == "shopping" {
                emoji = "👠"
            }
            else if entry.category == "health" {
                emoji = "🏥"
            }
            else if entry.category == "travel" {
                emoji = "✈️"
            }
            else if entry.category == "bills" {
                emoji = "📞"
            }
            else if entry.category == "investments" {
                emoji = "💰"
            }
            else if entry.category == "income" {
                emoji = "💸"
            }
            displayedString = "\(displayedString)\n\(emoji)\(" ")\(cat)"
        }
        if let n = entry.note {
            displayedString = "\(displayedString)\n\("      ")\(n)"
        }
        

        cell.textLabel?.text = displayedString
        cell.textLabel?.numberOfLines = 0
        

        return cell
    }

    // fetch entry data
    func getData() {
        do {
            entries = try context.fetch(Entry.fetchRequest())
        }
        catch {
            print("Fetching Entry Data Failed")
        }
    }
    
    // fetch budget data
    func getBudgetData() {
        do {
            budgets = try context.fetch(Budget.fetchRequest())
        }
        catch {
            print("Fetching Budget Data Failed")
        }
    }

    // tableView delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let budget = budgets[indexPath.row]
            let entry = entries.reversed()[indexPath.row]
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "M"
            let deleted_month = Int(dateFormatter.string(from: entry.date!))

            dateFormatter.dateFormat = "y"
            let deleted_year = Int(dateFormatter.string(from:entry.date!))

            // delete the entry amount from the corresponding budget sum
            for b in budgets {
                let m: Int = Int(b.month)
                let y: Int = Int(b.year)
                if (m == deleted_month) && (y == deleted_year){
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
                        
                        if category != "income" {
                            // update sum
                            b.sum -= num
                        }

                        switch category {
                            case "food":
                                b.food -= num
                            case "housing":
                                b.housing -= num
                            case "transport":
                                b.transport -= num
                            case "travel":
                                b.travel -= num
                            case "bills":
                                b.bills -= num
                            case "investments":
                                b.investments -= num
                            case "shopping":
                                b.shopping -= num
                            case "health":
                                b.health -= num
                            case "income":
                                b.income -= num
                            default:
                                print("invalid category")
                        }
                    }
                    break
                }
            }
            
            // delete selected entry and update context
            context.delete(entry)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            do {
                entries = try context.fetch(Entry.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
        
        if(entries.last!.date != nil){
            let name = entries.last!.date!
            
            getImage(String(describing:(name)))
        }
    }


}



