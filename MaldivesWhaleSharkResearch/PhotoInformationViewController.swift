//
//  PhotoInformationViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoInformationViewController: UIViewController, EditPhotoDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var location: CLLocation?{
        didSet{
            if let location = location{
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
                    if (placemarksArray?.count)! > 0 {
                        
                        let placemark = placemarksArray?.first
                        var string = String()
                        // Tell city, state, locale of pin
//                        if let state = placemark!.administrativeArea{
//                            string.append(state)
//                        }
//                        if let city = placemark!.locality{
//                            string.append(": \(city)")
//                        }else{
//                            if let subcity = placemark!.subLocality{
//                                string.append(": \(subcity)")
//                            }
//                        }
                        if let latitude = placemark!.location?.coordinate.latitude {
                            string.append(String(latitude))
                        }
                        if let longitude = placemark!.location?.coordinate.longitude {
                            string.append(", \(String(longitude))")
                        }
                        self.locationLabel.text = string
                    }
                }
            }else{
                locationLabel.text = ""
            }
        }
    }
    var photoDate: Date? {
        didSet {
            if let date = photoDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-dd-MM"
                let dateString = dateFormatter.string(from: date)
                timestampLabel.text = dateString
            }
        }
    }

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Status Bar Hidden
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    override public var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        // Set up alert prior to cancel
        let alert = UIAlertController(title: "Cancel Upload", message: "Are you sure you want to cancel your Whale Shark upload?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No, Continue Upload", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, Cancel Upload", style: UIAlertActionStyle.destructive, handler: { (action) in
            
            // If user has confirmed dismiss view
            self.dismiss(animated: true, completion: nil)
        }))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "infoToEditSegue", sender: nil)
    }

    @IBAction func reportEncounterButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "infoToReportSegue", sender: nil)
    }
    
    @IBAction func cancelToPhotoInfoViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func savePhotoInfo(segue:UIStoryboardSegue) {
    }
    
    // MARK: - Edit Info Delegate
    func informationEdited(_ location: CLLocation?, photoDate: Date?) {
        self.location = location
        self.photoDate = photoDate
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "infoToEditSegue" {
            let editPhotoVC = segue.destination as! EditPhotoInformationViewController
            editPhotoVC.newImage = self.imageView.image
            editPhotoVC.location = location
            editPhotoVC.photoDate = photoDate
            editPhotoVC.delegate = self
        } else if segue.identifier == "infoToReportSegue" {
            let reportPhotoVC = segue.destination as! ReportEncounterViewController
            reportPhotoVC.selectedImage = self.imageView.image
        }
        
    }

}
