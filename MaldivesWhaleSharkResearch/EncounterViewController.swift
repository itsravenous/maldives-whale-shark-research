//
//  EncounterViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/30/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class EncounterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var encounterDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var contributorNameLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    
    // MARK: - Properties
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //        self.navigationItem.title = model.encounter[selectedIndexPath.row]["name"]
        //        self.navigationController?.navigationBar.titleTextAttributes = [
        //            NSFontAttributeName: UIFont(name: "MuseoSans-500", size: 19)!,
        //            NSForegroundColorAttributeName: UIColor.white
        //        ]
        //        self.contributorImageView.image = UIImage(named: model.encounter[selectedIndexPath.row]["contributorImage"]!)
    }
    
    // MARK: - IBActions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        // image to share
        let image = UIImage(named: "shark1")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //        activityViewController.excludedActivityTypes = [ UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}
