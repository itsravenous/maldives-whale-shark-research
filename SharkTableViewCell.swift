//
//  SharkTableViewCell.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/8/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class SharkTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var sharkImageView: UIImageView!
    @IBOutlet weak var sharkNameLabel: UILabel!
    @IBOutlet weak var sharkIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
