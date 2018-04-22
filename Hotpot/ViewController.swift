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
import Charts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // store an array of entries
    var entries:[Entry] = []

    var budgets:[Budget] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UITableViewCell.self,
//                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // display slider menu page
        sideMenus()

    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        getBudgetData()
        print("budget count: \(budgets.count)")
        tableView.reloadData()
        
        for b in budgets {
            print(b)
            //context.delete(b)
            print("hi")
        }
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//        getBudgetData()
//        print("budget count: \(budgets.count)")

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
            else if entry.category == "Housing" {
                emoji = "🏠"
            }
            else if entry.category == "Transport" {
                emoji = "🚗"
            }
            else if entry.category == "Shopping" {
                emoji = "👠"
            }
            else if entry.category == "Health" {
                emoji = "🏥"
            }
            else if entry.category == "Travel" {
                emoji = "✈️"
            }
            else if entry.category == "Bills" {
                emoji = "📞"
            }
            else if entry.category == "Investments" {
                emoji = "💰"
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
            let entry = entries[indexPath.row]
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
                        
                        // update sum
                        b.sum -= num
                        
                        let category = entry.category!

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
    }


}



