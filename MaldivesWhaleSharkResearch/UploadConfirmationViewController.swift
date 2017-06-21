//
//  UploadConfirmationViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/17/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Spring

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

    }
    
    // MARK: - Actions
    @IBAction func viewProfileButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sharkResultSegue", sender: nil)
//        let stb = UIStoryboard(name: "Main", bundle: nil)
//        let sharkProfile = stb.instantiateViewController(withIdentifier: "sharkProfile") as! SharkProfileTableViewController
//        self.present(sharkProfile, animated: true) { 
//            
//        }
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
