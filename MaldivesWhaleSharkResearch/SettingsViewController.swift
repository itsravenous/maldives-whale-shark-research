//
//  SettingsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/8/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Get the current user and set up their image and namelabel
        
        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.displayName
            let photoURL = user.photoURL
            
            self.nameLabel.text = name
            self.imageView.sd_setImage(with: photoURL)
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        // Set up alert prior to logout
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertActionStyle.default, handler: { (action) in
            
            // If user has confirmed log out dismiss view
            let userDefaults = UserDefaults.standard
            
            if userDefaults.bool(forKey: "signedIn") == true {
                userDefaults.set(false, forKey: "signedIn")
                userDefaults.synchronize()
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)

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
