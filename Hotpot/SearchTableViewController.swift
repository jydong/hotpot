//
//  SearchTableViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/7/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var entries:[Entry] = []
    
    var filteredEntries = [Entry]()

    
    var notes:[String] = []
//    var notes = ["food", "gs", "sd", " djdj", "fdfsad"]
    var filteredNotes = [String]()
    
    var searchController: UISearchController!
    var resultController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all notes

        self.resultController.tableView.dataSource = self
        self.resultController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        //Filter through the entries
        
        self.filteredEntries = []
        
        for entry in entries{
            if entry.note?.range(of: self.searchController.searchBar.text!) != nil{
                filteredEntries.append(entry)
            }
        }

        
//        self.filteredNotes = self.notes.filter{ (note: String) -> Bool in
//            if note.range(of: self.searchController.searchBar.text!) != nil{
//                print(filteredNotes)
//                return true
//            }else{
////
//                return false
//            }
//        }
        
        //update the results
        self.resultController.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        getData()
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return entries.count
        }else{
            return filteredEntries.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if tableView == self.tableView{
//            cell.textLabel?.text = self.notes[indexPath.row]
            
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
            
        }else{
            let entry = filteredEntries[indexPath.row]
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
//            cell.textLabel?.text = self.filteredNotes[indexPath.row]
//            cell.textLabel?.numberOfLines = 0
        }
        

        return cell
    }
    
    func getData() {
        do {
            entries = try context.fetch(Entry.fetchRequest())
//            for entry in entries {
//                self.notes.append(entry.note!)
//            }
        }
        catch {
            print("Fetching Failed")
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//extension String {
//    func contains(find: String) -> Bool{
//        return self.range(of: find) != nil
//    }
//    func containsIgnoringCase(find: String) -> Bool{
//        return self.range(of: find, options: .caseInsensitive) != nil
//    }
//}

