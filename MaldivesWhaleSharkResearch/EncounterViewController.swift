//
//  EncounterViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/30/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class EncounterViewController: UIViewController {
    
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
    
    // MARK: - Outlets
    @IBOutlet weak var sharkImageView: UIImageView!
    @IBOutlet weak var encounterDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var contributorNameLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    var selectedIndexPath = IndexPath()
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
