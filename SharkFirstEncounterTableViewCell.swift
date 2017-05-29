//
//  SharkFirstEncounterTableViewCell.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/9/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import MapKit

class SharkFirstEncounterTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var firstEncounterDateLabel: UILabel!
    @IBOutlet weak var firstEncounterLengthLabel: UILabel!
    @IBOutlet weak var firstEncounterSeenByLabel: UILabel!
    @IBOutlet weak var firstEncounterMapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
