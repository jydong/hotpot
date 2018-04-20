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
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // store an array of entries
    var entries:[Entry] = []
    
    
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
        tableView.reloadData()
    }

    // get tableView cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    // display tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let entry = entries[indexPath.row]
        print(entry)
        

        var displayedString = ""
        var emoji = "🍔"
        
        
        if let cur = entry.currency {
            displayedString = "\("      ")\(cur)"
        }
        
//        if let a = entry.amount {
//            displayedString = "\(displayedString)\(" ")\(a)"
//        }
        
        displayedString = "\(displayedString)\(" ")\(entry.amount)"
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

    // fetch data
    func getData() {
        do {
            entries = try context.fetch(Entry.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }

    // tableView delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
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



