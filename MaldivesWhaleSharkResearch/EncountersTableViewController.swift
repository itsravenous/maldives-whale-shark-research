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

class EncountersTableViewController: UITableViewController, BWWalkthroughViewControllerDelegate {
    
    // MARK: - View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
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
//            if menuPath == 0 {
//                self.showAllEncounters()
//                print("all")
//            } else if menuPath == 1 {
//                self.showLikedEncounters()
//                print("liked")
//            } else if menuPath == 2 {
//                self.showMyEncounter()
//                print("my")
//            } else {
//                self.showAllEncounters()
//                print("all-default")
//            }
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
        return model.encounter.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "encounterCell", for: indexPath) as! EncounterTableViewCell
        cell.sharkImageView.image = UIImage(named: model.encounter[indexPath.row]["sharkImage"]!)
        cell.sharkNameLabel.text = model.encounter[indexPath.row]["name"]
        cell.dateSeenLabel.text = "Spotted " + model.encounter[indexPath.row]["lastSeen"]! + " days ago"
        cell.contributorImageView.image = UIImage(named: model.encounter[indexPath.row]["contributorImage"]!)

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
