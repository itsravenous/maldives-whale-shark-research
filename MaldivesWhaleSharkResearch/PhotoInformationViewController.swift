//
//  PhotoInformationViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class PhotoInformationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!


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
        alert.addAction(UIAlertAction(title: "No, Continue Upload", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, Cancel Upload", style: UIAlertActionStyle.default, handler: { (action) in
            
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}