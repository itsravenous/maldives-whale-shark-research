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
    
    // MARK: - Properties
    var encounterId = String()
    let ref = Database.database().reference()
    
    
    // MARK: - When Cell Loads
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.layoutIfNeeded()
        contributorImageView.layer.cornerRadius = contributorImageView.frame.width/2
        contributorImageView.layer.masksToBounds = true
    }

}
