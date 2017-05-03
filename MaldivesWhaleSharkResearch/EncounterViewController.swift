//
//  EncounterViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/30/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class EncounterViewController: UIViewController {
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = model.encounter[selectedIndexPath.row]["name"]
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MuseoSans-500", size: 19)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        self.contributorImageView.image = UIImage(named: model.encounter[selectedIndexPath.row]["contributorImage"]!)
    }
    
    // MARK: - Properties
    @IBOutlet weak var sharkImageView: UIImageView!
    @IBOutlet weak var encounterDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var contributorNameLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    var selectedIndexPath = IndexPath()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
