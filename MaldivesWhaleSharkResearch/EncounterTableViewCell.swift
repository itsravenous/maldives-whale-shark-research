//
//  EncounterTableViewCell.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/29/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EncounterTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var sharkImageView: UIImageView!
    @IBOutlet weak var sharkNameLabel: UILabel!
    @IBOutlet weak var dateSeenLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    // MARK: - Properties
    var encounterId = String()
    let ref = Database.database().reference()
    
    // MARK: - IBActions
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.ref.child("users/\(user.uid)/liked_encounters").child(self.encounterId).setValue(true)
                self.likeButton.isHidden = true
                self.dislikeButton.isHidden = false
            } else {
                print("no user signed in")
            }
        })
    }
    
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.ref.child("users/\(user.uid)/liked_encounters").child(self.encounterId).removeValue()
                self.likeButton.isHidden = false
                self.dislikeButton.isHidden = true
            } else {
                print("no user signed in")
            }
        })
    }
    
    
    // MARK: - When Cell Loads
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.layoutIfNeeded()
        contributorImageView.layer.cornerRadius = contributorImageView.frame.width/2
        contributorImageView.layer.masksToBounds = true
    }

}
