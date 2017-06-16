//
//  ComparisonResultsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController

class ComparisonResultsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var sharkUploadImageView: UIImageView!
    @IBOutlet weak var sharkResultsImageView: UIImageView!
    @IBOutlet weak var sharkResultsCollectionView: UICollectionView!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Status Bar Hidden
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    override public var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
    }

    @IBAction func confirmMatchButtonPressed(_ sender: UIButton) {
        // Set up alert prior to logout
        let alert = UIAlertController(title: "Any more photos?", message: "Add more photos of your encounter to help identify the shark.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No photos", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Select Photos", style: UIAlertActionStyle.default, handler: { (action) in
            
            let pickerController = DKImagePickerController()
            
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                print("didSelectAssets")
                print(assets)
            }
            
            self.present(pickerController, animated: true) {}
            
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
