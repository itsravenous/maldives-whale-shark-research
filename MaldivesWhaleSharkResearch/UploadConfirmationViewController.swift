//
//  UploadConfirmationViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/17/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Spring
import AlgoliaSearch

class UploadConfirmationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var sharkImage: UIImageView!
    @IBOutlet weak var sharkNameLabel: UILabel!
    @IBOutlet weak var viewProfileButton: UIButton!

    // MARK: - Properties
    var selectedImage: UIImage!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        sharkImage.image = selectedImage
        viewProfileButton.layer.cornerRadius = 4

    }
    
    // MARK: - Navigation Bar Stuff
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MuseoSans-500", size: 19)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    // MARK: - Actions
    @IBAction func viewProfileButtonPressed(_ sender: UIButton) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = stb.instantiateViewController(withIdentifier: "tabBar") as! TabBarViewController
        let nav = tabBar.viewControllers?[3] as! UINavigationController
        let sharkProfile = stb.instantiateViewController(withIdentifier: "sharkProfile") as! SharkProfileTableViewController
        tabBar.selectedIndex = 3
        let shark =
            [
                "id" : "WS004",
                "name": "Nathan",
                "sighting_count": "5",
                "sex": "M",
                "first_datetime": "2008-05-18 14:10:00",
                "first_length": "7",
                "first_contributor": "MWSRP",
                "first_location": "3.465500, 72.838256",
                "last_datetime": "2012-12-22 15:35:00",
                "last_length": "7",
                "last_contributor": "MWSRP",
                "last_location": "3.565500, 72.938256",
                "media": [["thumb_url": "https://mwsrp-network.org/uploads/sharks/thumbs/WS004/WS004%20R%20PECT.JPG"]]
                ] as [String : Any]
        sharkProfile.selectedShark = shark as JSONObject
        self.present(tabBar, animated: true) {
            nav.pushViewController(sharkProfile, animated: false)
        }
        
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
