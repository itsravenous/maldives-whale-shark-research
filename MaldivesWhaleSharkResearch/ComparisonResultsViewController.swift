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

class ComparisonResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var sharkUploadImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    
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
        UINavigationBar.appearance().barTintColor = UIColor(red: 80.0/255.0, green: 210.0/255.0, blue: 195.0, alpha: 1.0)

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
    
    // MARK: - Functions
    func presentImagePicker() {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 8
        pickerController.showsEmptyAlbums = false
        pickerController.assetType = .allPhotos
        pickerController.sourceType = .photo
        pickerController.showsCancelButton = true
        
        pickerController.didCancel = { ()
            print("didCancel")
        }
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
        }
        
        self.present(pickerController, animated: true) {}
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
        alert.addAction(UIAlertAction(title: "No photos", style: .destructive, handler: { (action) in
            self.performSegue(withIdentifier: "uploadEncounterSegue", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Select Photos", style: UIAlertActionStyle.default, handler: { (action) in
            self.presentImagePicker()
        }))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CollectionViewDelegate/Datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharkCell", for: indexPath) as! SharkInfoCollectionViewCell
        cell.sharkImage.image = UIImage(named: "shark1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadEncounterSegue" {
            let destinationVC = segue.destination as! UploadResultsViewController
            destinationVC.selectedImage = sharkUploadImageView.image
        }
    }


}


