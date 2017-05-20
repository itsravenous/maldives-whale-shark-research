//
//  AllTimeViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AllTimeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var contributorsLabel: UILabel!
    @IBOutlet weak var excursionsLabel: UILabel!
    @IBOutlet weak var encountersLabel: UILabel!
    @IBOutlet weak var successRateLabel: UILabel!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRDatabase.database().reference().child("stats").child("all").observe(.value, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            // Contributors
            let contributors = snapshotValue!["contributors"] as! Int
            self.contributorsLabel.text = String(contributors)
            
            // Excursions
            let excursions = snapshotValue!["trips"] as! Int
            self.excursionsLabel.text = String(excursions)
            
            // Encounters
            let encounters = snapshotValue!["encounters"] as! Int
            self.encountersLabel.text = String(encounters)
            
            // Success
            let success = snapshotValue!["success"] as! Int
            self.successRateLabel.text = String(success) + "%"
            
        })
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
