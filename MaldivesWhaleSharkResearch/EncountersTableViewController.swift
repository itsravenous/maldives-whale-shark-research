//
//  EncountersTableViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/29/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import BWWalkthrough
import BTNavigationDropdownMenu
import FirebaseDatabase
import SDWebImage

class EncountersTableViewController: UITableViewController, BWWalkthroughViewControllerDelegate  {
    
    var encounters : [Encounter] = []

    // MARK: - View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Firebase info tableview
        
        FIRDatabase.database().reference().child("encounters").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            let encounter = Encounter()
            encounter.sharkName = (snapshotValue?["sharkName"] as? String)!
            encounter.date = (snapshotValue?["date"] as? String)!
            encounter.contributorID = (snapshotValue?["contributorID"] as? String)!
            
            let photoValue = (snapshotValue?["photos"] as? NSDictionary)
            encounter.mainImage = (photoValue?["imageURL1"] as? String)!
            
            self.encounters.append(encounter)
            
            self.tableView.reloadData()
        })

        // Create the menuview
        
        let items = ["All Encounters", "Liked Encounters", "My Encounters"]
        let menuView = BTNavigationDropdownMenu(title: items[0], items: items as [AnyObject])
        menuView.navigationBarTitleFont = UIFont(name: "MuseoSans-500", size: 19)
        menuView.cellHeight = 65
        menuView.cellBackgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        menuView.cellSelectionColor = UIColor(red: 66.0/255.0, green:66.0/255.0, blue:66.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "MuseoSans-500", size: 16)
        menuView.cellSeparatorColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        menuView.cellTextLabelAlignment = .center // .center // .right // .left
        menuView.selectedCellTextLabelColor = UIColor.white
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(menuPath: Int) -> () in
            print("Did select item at index: \(menuPath)")
            if menuPath == 0 {
                self.showAllEncounters()
                print("all")
            } else if menuPath == 1 {
                self.showLikedEncounters()
                print("liked")
            } else if menuPath == 2 {
                self.showMyEncounter()
                print("my")
            }
        }
        
        self.navigationItem.titleView = menuView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func uploadImageButtonPressed(_ sender: UIBarButtonItem) {
        print("Upload Image Button Pressed")
        
    }
    
    // MARK: - Functions
    
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
    
    // Convert date from date string and subtract from current date
    
    func convertDate(encounterDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: encounterDate)
        
        let currentDate = Date()
        let calendar = NSCalendar.current
        let dayOfEncounter = calendar.startOfDay(for: date!)
        let today = calendar.startOfDay(for: currentDate)
        
        let components = calendar.dateComponents([.day], from: dayOfEncounter, to: today)
        
        return String(describing: components.day!)
    }
    
    // Get user id info and find their contributorImage
    
    func getContributorImage(contributorID: String) -> String {
        
        var contributorImage = ""
        
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            
            let userSnapshotValue = snapshot.value as? NSDictionary
//            contributorImage = (userSnapshotValue?["contributorImage"] as? String)!
            
        })
        
        return contributorImage
        
    }
    
    
    // MARK: - Encounter filters
    
    func showAllEncounters() {

        self.tableView.reloadData()
    }
    
    func showLikedEncounters() {
        
        self.tableView.reloadData()
    }
    
    func showMyEncounter() {
        
        self.tableView.reloadData()
    }
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return encounters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "encounterCell", for: indexPath) as! EncounterTableViewCell
        let encounter = encounters[indexPath.row]
        cell.sharkNameLabel.text = encounter.sharkName
        cell.dateSeenLabel.text = "Spotted " + convertDate(encounterDate: encounter.date) + " days ago"
        cell.sharkImageView.sd_setImage(with: URL(string: encounter.mainImage))
        cell.contributorImageView.sd_setImage(with: URL(string: getContributorImage(contributorID: encounter.contributorID)))
// below works, firebase urls don't
//        cell.contributorImageView.sd_setImage(with: URL(string: "https://image.flaticon.com/teams/new/1-freepik.jpg"))
        
        return cell
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToEncounterCard" {
            let destination = segue.destination as! EncounterViewController
            destination.selectedIndexPath = tableView.indexPathForSelectedRow!
        }
    }

}
