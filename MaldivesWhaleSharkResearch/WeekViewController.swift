//
//  WeekViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import SDWebImage

class WeekViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var weeklyEncountersLabel: UILabel!
    @IBOutlet weak var weeklyEncounterDeltaLabel: UILabel!
    @IBOutlet weak var uniqueSharksLabel: UILabel!
    @IBOutlet weak var uniqueSharksDeltaLabel: UILabel!
    @IBOutlet weak var topLocationMapView: MKMapView!
    @IBOutlet weak var topLocationNameLabel: UILabel!
    @IBOutlet weak var topContributorImageView: UIImageView!
    @IBOutlet weak var topContributorNameLabel: UILabel!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().reference().child("stats").child("weekly").observe(.value, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            // Weekly Encounters
            let weeklyEncounters = snapshotValue!["encounters"] as! Int
            self.weeklyEncountersLabel.text = String(weeklyEncounters)
            
            let weeklyEncountersDelta = snapshotValue!["encounters_delta"] as! Int
            
            if (weeklyEncountersDelta < 0) {
                self.weeklyEncounterDeltaLabel.textColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1)
                self.weeklyEncounterDeltaLabel.text = "-" + "\(String(weeklyEncountersDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(weeklyEncounters), initialValue: (Double(weeklyEncounters - weeklyEncountersDelta))))" + "%)"
            } else {
                self.weeklyEncounterDeltaLabel.textColor = UIColor(red: 0.0/255.0, green: 227.0/255.0, blue: 151.0/255.0, alpha: 1)
                self.weeklyEncounterDeltaLabel.text = "+" + "\(String(weeklyEncountersDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(weeklyEncounters), initialValue: (Double(weeklyEncounters - weeklyEncountersDelta))))" + "%)"
            }
            
            // Unique Sharks
            let uniqueSharks = snapshotValue!["unique_sharks"] as! Int
            self.uniqueSharksLabel.text = String(uniqueSharks)
            
            let uniqueSharksDelta = snapshotValue!["unique_sharks_delta"] as! Int
            if (uniqueSharksDelta < 0) {
                self.uniqueSharksDeltaLabel.textColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1)
                self.uniqueSharksDeltaLabel.text = "\(String(uniqueSharksDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(uniqueSharks), initialValue: (Double(uniqueSharks - uniqueSharksDelta))))" + "%)"
            } else {
                self.uniqueSharksDeltaLabel.textColor = UIColor(red: 0.0/255.0, green: 227.0/255.0, blue: 151.0/255.0, alpha: 1)
                self.uniqueSharksDeltaLabel.text = "+" + "\(String(uniqueSharksDelta))" + " (" + "\(self.findDeltaPercentage(finalValue: Double(uniqueSharks), initialValue: (Double(uniqueSharks - uniqueSharksDelta))))" + "%)"
            }
            
            // Top Location
            let topLocation = snapshotValue!["top_location"] as! NSDictionary
            self.topLocationNameLabel.text = topLocation["name"] as? String

            // 1
            let lat = topLocation["latitude"] as? Double
            let long = topLocation["longitude"] as? Double
            let location = CLLocationCoordinate2D(
                latitude: lat!,
                longitude: long!
            )
            // 2
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            self.topLocationMapView.setRegion(region, animated: false)
            
//            Add annotation
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = "Lux"
//            annotation.subtitle = "Maldives"
//            mapView.addAnnotation(annotation)
            
            // Top Contributor
            let topContributor = snapshotValue!["top_contributor"] as! NSDictionary
            self.topContributorNameLabel.text = topContributor["name"] as? String
            
            let topContributorImage = topContributor["logo"] as! String
            self.topContributorImageView.sd_setImage(with: URL(string: topContributorImage))
            
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
