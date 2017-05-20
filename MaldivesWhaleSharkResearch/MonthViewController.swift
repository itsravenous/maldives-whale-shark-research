//
//  MonthViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class MonthViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var newSharksLabel: UILabel!
    @IBOutlet weak var newSharksDeltaLabel: UILabel!
    @IBOutlet weak var topSharkImageView: UIImageView!
    @IBOutlet weak var topSharkNameLabel: UILabel!
    @IBOutlet weak var newInjuriesLabel: UILabel!
    @IBOutlet weak var newInjuriesDeltaLabel: UILabel!
    @IBOutlet weak var averageEncounterDurationLabel: UILabel!
    @IBOutlet weak var averageEncounterDurationDeltaLabel: UILabel!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRDatabase.database().reference().child("stats").child("monthly").observe(.value, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            // New Sharks Encounters
            let newSharks = snapshotValue!["new_sharks"] as! Int
            self.newSharksLabel.text = String(newSharks)
            
            let newSharksDelta = snapshotValue!["new_sharks_delta"] as! Int
            
            if (newSharksDelta < 0) {
                self.newSharksDeltaLabel.textColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1)
                self.newSharksDeltaLabel.text = "\(String(newSharksDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(newSharks), initialValue: (Double(newSharks - newSharksDelta))))" + "%)"
            } else {
                self.newSharksDeltaLabel.textColor = UIColor(red: 0.0/255.0, green: 227.0/255.0, blue: 151.0/255.0, alpha: 1)
                self.newSharksDeltaLabel.text = "+" + "\(String(newSharksDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(newSharks), initialValue: (Double(newSharks - newSharksDelta))))" + "%)"
            }
            
            // Top Shark
            let topShark = snapshotValue!["top_shark"] as! NSDictionary
            self.topSharkNameLabel.text = (topShark["id"] as? String)! + " " + (topShark["name"] as? String)!
            
            let topSharkImage = topShark["image"] as! String
            self.topSharkImageView.sd_setImage(with: URL(string: topSharkImage))

            
            // New Injuries
            let newInjury = snapshotValue!["new_injuries"] as! Int
            self.newInjuriesLabel.text = String(newInjury)
            
            let newInjuryDelta = snapshotValue!["new_injuries_delta"] as! Int
            
            if (newInjuryDelta > 0) {
                self.newInjuriesDeltaLabel.textColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1)
                self.newInjuriesDeltaLabel.text = "+" + "\(String(newInjuryDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(newInjury), initialValue: (Double(newInjury - newInjuryDelta))))" + "%)"
            } else {
                self.newInjuriesDeltaLabel.textColor = UIColor(red: 0.0/255.0, green: 227.0/255.0, blue: 151.0/255.0, alpha: 1)
                self.newInjuriesDeltaLabel.text = "\(String(newInjuryDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(newInjury), initialValue: (Double(newInjury - newInjuryDelta))))" + "%)"
            }
            
            // Average Encounter
            let averageEncounter = snapshotValue!["avg_encounter_duration"] as! Int
            self.averageEncounterDurationLabel.text = String(averageEncounter) + "m"
            
            let durationDelta = snapshotValue!["avg_encounter_duration_delta"] as! Int
            
            if (durationDelta < 0) {
                self.averageEncounterDurationDeltaLabel.textColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1)
                self.averageEncounterDurationDeltaLabel.text = "\(String(durationDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(averageEncounter), initialValue: (Double(averageEncounter - durationDelta))))" + "%)"
            } else {
                self.averageEncounterDurationDeltaLabel.textColor = UIColor(red: 0.0/255.0, green: 227.0/255.0, blue: 151.0/255.0, alpha: 1)
                self.averageEncounterDurationDeltaLabel.text = "+" + "\(String(durationDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(averageEncounter), initialValue: (Double(averageEncounter - durationDelta))))" + "%)"
            }
            
        })
        
    }
    
    // MARK: - Functions
    func findDeltaPercentage(finalValue:Double, initialValue:Double) -> String {
        let difference = finalValue - initialValue
        let result = ((difference/initialValue) * 100)
        return String(format: "%.2f", result)
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
