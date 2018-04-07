//
//  ViewController.swift
//  Hotpot
//
//  Created by Jingyan Dong on 4/2/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // store an array of entries
    //var entries:[NSManagedObject] = []
    var entries:[Entry] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UITableViewCell.self,
//                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        sideMenus()
        
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Entry")
//        request.returnsObjectsAsFaults = false
//        do{
//            let result = try context.fetch(request)
//            if result.count > 0 {
//                for res in result as! [NSManagedObject] {
//                    if let a = res.value(forKey:"amount") as? String{
//                        print(a)
//                    }
//                }
//            }
//        }
//        catch{
//
//        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let entry = entries[indexPath.row]
        print(entry)
        
        //cell.textLabel?.text = entries[(indexPath as NSIndexPath).row]

        var displayedString = ""
        var emoji = "🍔"
        
       
        
        if let cur = entry.currency {
            displayedString = "\("      ")\(cur)"
        }
        
        if let a = entry.amount {
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
        
//        if let a = entry.amount {
//            cell.textLabel?.text = "\(a)\n\(a)"
//            cell.textLabel?.numberOfLines = 0
//        }

        return cell
    }

    func getData() {
        do {
            entries = try context.fetch(Entry.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }

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

//// MARK: - UITableViewDataSource
//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return entries.count
//    }
//
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//
//            let entry = entries[indexPath.row]
//            let cell =
//                tableView.dequeueReusableCell(withIdentifier: "Cell",
//                                              for: indexPath)
//            cell.textLabel?.text =
//                entry.value(forKeyPath: "amount") as? String
//            return cell
//    }
//}

