//
//  EncounterTableViewCell.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/29/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class EncounterTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var sharkImageView: UIImageView!
    @IBOutlet weak var sharkNameLabel: UILabel!
    @IBOutlet weak var dateSeenLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - When Cell Loads
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        contributorImageView.layer.cornerRadius = contributorImageView.frame.width/2
        contributorImageView.layer.masksToBounds = true
    }

}
