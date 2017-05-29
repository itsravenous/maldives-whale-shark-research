//
//  SharkDescriptionTableViewCell.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/9/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class SharkDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var sharkNameLabel: UILabel!
    @IBOutlet weak var sharkSexImageView: UIImageView!
    @IBOutlet weak var sharkIdLabel: UILabel!
    @IBOutlet weak var sharkSexLineImageView: UIImageView!
    @IBOutlet weak var sharkTotalEncountersLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
