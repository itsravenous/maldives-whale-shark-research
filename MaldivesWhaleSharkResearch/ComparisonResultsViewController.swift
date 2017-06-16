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
import CenteredCollectionView

class ComparisonResultsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var sharkUploadImageView: UIImageView!
    @IBOutlet weak var sharkResultsImageView: UIImageView!
    @IBOutlet weak var sharkResultsCollectionView: UICollectionView!
    
    // MARK: - Properties
    var selectedImage: UIImage!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        sharkUploadImageView.image = selectedImage
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MuseoSans-500", size: 19)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        UINavigationBar.appearance().barTintColor = UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0, alpha: 1.0)
        
        let centeredCollectionView = CenteredCollectionView()
        
        // delegate & data source
        // implement the delegate and data source as you would a UICollectionView
        centeredCollectionView.delegate = self
        centeredCollectionView.dataSource = self
        
        // register collection cells
        centeredCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        
        // configure centeredCollectionView properties
        centeredCollectionView.itemSize = CGSize(width: 100, height: 100)
        centeredCollectionView.minimumLineSpacing = 20
        
        // get rid of scrolling indicators
        centeredCollectionView.showsVerticalScrollIndicator = false
        centeredCollectionView.showsHorizontalScrollIndicator = false

        
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
        // Set up alert prior to cancel
        let alert = UIAlertController(title: "Cancel Upload", message: "Are you sure you want to exit the photo upload?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes, cancel", style: UIAlertActionStyle.destructive, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No, continue", style: UIAlertActionStyle.default, handler: nil))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func confirmMatchButtonPressed(_ sender: UIButton) {
        // Set up alert prior to logout
        let alert = UIAlertController(title: "Any more photos?", message: "Add more photos of your encounter to help confirm your shark.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No photos", style: UIAlertActionStyle.destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Select Photos", style: UIAlertActionStyle.default, handler: { (action) in
            
            let pickerController = DKImagePickerController()
            pickerController.maxSelectableCount = 8
//            pickerController.showsEmptyAlbums = false
//            pickerController.assetType = .allPhotos
//            pickerController.sourceType = .photo
//            pickerController.allowMultipleTypes = false
            pickerController.showsCancelButton = true
            
            pickerController.didCancel = { ()
                print("didCancel")
            }
            
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
