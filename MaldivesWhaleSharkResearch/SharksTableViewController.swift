//
//  SharksTableViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/8/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class SharksTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSearchBar()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-bar"), for: .default)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive == true {
            return searchResults.count
        } else {
            return model.sharks.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharkCell", for: indexPath) as! SharkTableViewCell

        // Configure the cell...
        if searchController.isActive == true {
            cell.sharkNameLabel.text = searchResults[indexPath.row]["name"] as! String
            cell.sharkIDLabel.text = searchResults[indexPath.row]["id"] as! String
            cell.sharkImageView.image = UIImage(named: (searchResults[indexPath.row]["image"]! as! String))
        } else {
            cell.sharkNameLabel.text = model.sharks[indexPath.row]["name"]
            cell.sharkIDLabel.text = model.sharks[indexPath.row]["id"]
            cell.sharkImageView.image = UIImage(named: (model.sharks[indexPath.row]["image"]!))
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // MARK: - Search Controller
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults = [AnyObject]()
    
    // MARK: UISearchResultsUpdating Protocol
    func loadSearchBar() {
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sharks by Name"
        searchController.searchBar.barTintColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        searchController.searchBar.keyboardAppearance = .dark
                
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // get data as nsarray
        // filter data
        // return search results
        let predicate = NSPredicate(format: "name contains[cd] %@", searchController.searchBar.text!)

        let filteredResults = (model.sharks as NSArray).filtered(using: predicate)
        
        searchResults = filteredResults as [AnyObject]
        tableView.reloadData()
        
        //         print(filteredResults)
        //         print("Number of Results: \(filteredResults.count)")

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToSharkProfile" {
            let destination = segue.destination as! SharkProfileTableViewController
            destination.selectedIndexPath = tableView.indexPathForSelectedRow!
        }
    }

}
