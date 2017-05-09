//
//  SharkProfileTableViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/9/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class SharkProfileTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Close navigation gap
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCell", for: indexPath) as! SharkImagesTableViewCell
            sharkImagesCell = cell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! SharkDescriptionTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstEncounterCell", for: indexPath) as! SharkFirstEncounterTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastEncounterCell", for: indexPath) as! SharkLastEncounterTableViewCell
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 375
        case 1: return 270
        case 2: return 573
        default: return 573
            
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375
    }

    // MARK: - Did Detect Scrolling
    
    var sharkImagesCell: SharkImagesTableViewCell?
    var sharkCollectionViewCell: SharkImageCollectionViewCell?
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
        if let cell = sharkImagesCell {
            if scrollView.contentOffset.y < 0 {
                
                print(scrollView.contentOffset.y)
//                cell.imageViewTopConstraint.constant = scrollView.contentOffset.y
            }
        }
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.sharkImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharkPictureCell", for: indexPath) as! SharkImageCollectionViewCell
        cell.imageView.image = UIImage(named: model.sharkImages[indexPath.row]["image"]!)
        return cell
    }
    
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
