//
//  SearchTableViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/7/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

//This file will diplay a page with a search bar. The user can search by the keyword in the previous notes to filter the results. The table will be automatically updated while the user typing characters into the search bar. There is also a scope buttons to filter the results by currency type.

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var entries:[Entry] = []
    var filteredEntries:[Entry] = []

    
    var searchController: UISearchController!
    var resultController = UITableViewController()

    // this function will be called when the page is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultController.tableView.dataSource = self
        self.resultController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true // remove the white space on top of the cells
        
        self.searchController.searchBar.scopeButtonTitles = ["All", "USD"]
        self.searchController.searchBar.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }
    
    // filter entries by search input and scope
    func applySearch(searchText:String, scope:String = "All") {
        // filter by scope
        if searchController.searchBar.text! == ""{
            filteredEntries = entries.filter { entry in
                let entryCur = (scope == "All") || (entry.currency == scope)
                return entryCur
            }
            print("no search input")
        }
            
        // filter by search input and scope
        else{
            filteredEntries = entries.filter { entry in
                let entryCur = (scope == "All") || (entry.currency == scope)
                return entryCur && (entry.note!.lowercased().contains(searchText.lowercased()) || (entry.category!.lowercased() == (searchText.lowercased())) )
            }
        }
        
        for _ in filteredEntries {
            print("found 1 entry")
        }
        

        // update the results
        self.resultController.tableView.reloadData()
        
    }
    
    // update search results, call applySearch
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let selectedScope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        applySearch(searchText: searchController.searchBar.text!, scope:selectedScope)
    }
    
    // apply search inputs
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        applySearch(searchText: searchController.searchBar.text!,scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    // this function is sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // get the entry data and reload data
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    // display tableView based on cell count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return entries.count
        }
        else{
            return filteredEntries.count
        }
    }
    
    // display tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // update self.tableView
        if tableView == self.tableView{
            
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
                displayedString = "\(displayedString)\n\(emoji)\(" ")\(cat)"
            }
            if let n = entry.note {
                displayedString = "\(displayedString)\n\("      ")\(n)"
            }
            cell.textLabel?.text = displayedString
            cell.textLabel?.numberOfLines = 0
            
        }
        // update result tableView
        else{
            let entry = filteredEntries.reversed()[indexPath.row]
            
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
                displayedString = "\(displayedString)\n\(emoji)\(" ")\(cat)"
            }
            if let n = entry.note {
                displayedString = "\(displayedString)\n\("      ")\(n)"
            }
            cell.textLabel?.text = displayedString
            cell.textLabel?.numberOfLines = 0
        }
        
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
}

