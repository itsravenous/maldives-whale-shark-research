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
import BWWalkthrough

class SharksTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, SearchProgressDelegate, BWWalkthroughViewControllerDelegate, FusumaDelegate {
    
    // MARK: - Properties
    var uploadWalkthrough:BWWalkthroughViewController!
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
        sharkSearcher.params.attributesToRetrieve = ["name", "id", "sex", "sighting_count", "first_datetime", "first_length", "first_contributor", "first_location", "last_datetime", "last_length", "last_contributor", "last_location", "media"]
        
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
    
    // MARK: - Actions
    @IBAction func uploadImageButtonPressed(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        
        // Show photo upload
        if !userDefaults.bool(forKey: "uploadInstructions") {
            showInstructions()
            userDefaults.set(true, forKey: "uploadInstructions")
            userDefaults.synchronize()
        } else {
            showUploadPicture()
        }
    }
    
    // MARK: - Functions
    // Show initial walkthrough for first time user
    func showWalkthrough() {
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "container") as! BWWalkthroughViewController
        
        // Get view controllers and build the walkthrough
        let page_one = stb.instantiateViewController(withIdentifier: "page_1")
        let page_two = stb.instantiateViewController(withIdentifier: "page_2")
        let page_three = stb.instantiateViewController(withIdentifier: "page_3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    // Show instructions for image upload
    func showInstructions() {
        let stb = UIStoryboard(name: "UploadWalkthrough", bundle: nil)
        uploadWalkthrough = stb.instantiateViewController(withIdentifier: "container") as! BWWalkthroughViewController
        
        // Get view controllers and build the walkthrough
        let page_one = stb.instantiateViewController(withIdentifier: "page_1")
        let page_two = stb.instantiateViewController(withIdentifier: "page_2")
        let page_three = stb.instantiateViewController(withIdentifier: "page_3")
        let page_four = stb.instantiateViewController(withIdentifier: "page_4")
        
        // Attach the pages to the master
        uploadWalkthrough.delegate = self
        uploadWalkthrough.add(viewController:page_one)
        uploadWalkthrough.add(viewController:page_two)
        uploadWalkthrough.add(viewController:page_three)
        uploadWalkthrough.add(viewController:page_four)
        
        self.present(uploadWalkthrough, animated: true, completion: nil)
    }
    
    // Present image picker for photo upload
    func showUploadPicture() {
        let fusuma = FusumaViewController()
        
        fusumaCropImage = true
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        fusuma.hasVideo = false
        fusumaTintColor = UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1)
        fusumaBackgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1)
        self.present(fusuma, animated: true, completion: nil)
    }
    
    // MARK: - FusumaDelegate Protocol
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        let stb = UIStoryboard(name: "UploadPicture", bundle: nil)
        let photoInfo = stb.instantiateViewController(withIdentifier: "photoInfo") as! PhotoInformationViewController
        
        print("Image selected: \(image)")
        
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
        
        self.dismiss(animated: true, completion: nil)
        self.present(photoInfo, animated: true) {
            photoInfo.imageView.image = image
            photoInfo.photoDate = metaData.creationDate
            photoInfo.location = metaData.location
        }
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    func fusumaWillClosed() {
        
        print("Called when the close button is pressed")
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
        cell.sharkImageView.sd_setImage(with: URL(string: ((shark.media?[0])?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! ))
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSharkProfile" {
            let destination = segue.destination as! SharkProfileTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.selectedShark = self.sharkHits[indexPath.row]
            }
        }
    }

}
