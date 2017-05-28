//
//  SharksTableViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/8/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import SDWebImage
import AlgoliaSearch
import InstantSearchCore
import AFNetworking

class SharksTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, SearchProgressDelegate {
    
    var searchController: UISearchController!
    var searchProgressController: SearchProgressController!
    
    var sharkSearcher: Searcher!
    var sharkHits: [JSONObject] = []
    var originIsLocal: Bool = false
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Algolia Search
        sharkSearcher = Searcher(index: AlgoliaManager.sharedInstance.sharksIndex, resultHandler: self.handleSearchResults)
        sharkSearcher.params.hitsPerPage = 10
        sharkSearcher.params.attributesToRetrieve = ["name", "id", "mainImage"]
        
        // Search Controller
        loadSearchBar()
        
        // Configure search progress monitoring.
        searchProgressController = SearchProgressController(searcher: sharkSearcher)
        searchProgressController.delegate = self
        
        // First load
        updateSearchResults(for: searchController)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-bar"), for: .default)
        
        // Navigation Title blank
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Search completion handlers
    private func handleSearchResults(results: SearchResults?, error: Error?) {
        guard let results = results else { return }
        if results.page == 0 {
            sharkHits = results.hits
        } else {
            sharkHits.append(contentsOf: results.hits)
        }
        originIsLocal = results.content["origin"] as? String == "local"
        self.tableView.reloadData()
        print(sharkHits)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharkHits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharkCell", for: indexPath) as! SharkTableViewCell
        
        // Load more?
        if indexPath.row + 5 >= sharkHits.count {
            sharkSearcher.loadMore()
        }
        
        // Configure the cell...
        let shark = WhaleShark(json: sharkHits[indexPath.row])
        cell.sharkNameLabel.text = shark.name
        cell.sharkIDLabel.text = shark.id
        cell.sharkImageView.sd_setImage(with: shark.mainImage)
        
        cell.backgroundColor = originIsLocal ? AppDelegate.colorForLocalOrigin : UIColor.white


        return cell
    }
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        sharkSearcher.params.query = searchController.searchBar.text
        sharkSearcher.search()
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // MARK: - SearchProgressDelegate
    func searchDidStart(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func searchDidStop(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: UISearchResultsUpdating Protocol
    func loadSearchBar() {
        // Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sharks by Name"
        searchController.searchBar.barTintColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        searchController.searchBar.keyboardAppearance = .dark
        
        // Add the search bar
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = false
        searchController!.searchBar.sizeToFit()

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
