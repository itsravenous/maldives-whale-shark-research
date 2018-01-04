//
//  ComparisonResultsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Photos
import Firebase
import DKImagePickerController

class ComparisonResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var sharkUploadImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var collectionViewLabel: UICollectionView!
    
    // MARK: - Properties
    var selectedImage: UIImage!
    var results: [ComparisonResult] = []
    let pickerController = DKImagePickerController()
    var shark = Shark()
    var currentPage: Int = 0
    var currentResult: ComparisonResult!;
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionViewLabel.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionViewLabel.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 15)
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MuseoSans-500", size: 19)!,
            NSForegroundColorAttributeName: UIColor.black
        ]
        UINavigationBar.appearance().tintColor = UIColor.black
        
        self.setupLayout()
        
        self.currentPage = 0
        self.currentResult = self.results[0]
        let score2dp = (self.currentResult.score * 100).rounded() / 100
        self.ratingLabel.text = String(score2dp)

        sharkUploadImageView.image = selectedImage
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        if pickerController.selectedAssets.count >= 1 {
            self.performSegue(withIdentifier: "uploadEncounterSegue", sender: nil)
        }
    }
    
    // MARK: - Status Bar Hidden
    override public var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Functions
    func presentImagePicker() {
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
        let result = self.results[indexPath.row]
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharkCell", for: indexPath) as! SharkInfoCollectionViewCell
            cell.sharkImage.image = UIImage()
            let url = URL(string: result.image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            cell.sharkImage.sd_setShowActivityIndicatorView(true)
            cell.sharkImage.sd_setIndicatorStyle(.gray)
            cell.sharkImage.sd_setImage(with: url)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharkLabelCell", for: indexPath) as! SharkInfoLabelCollectionViewCell
            cell.lblID.text = result.id
            cell.lblName.text = result.name
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results.count
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageSide:CGFloat = 0
        var offset:CGFloat = 0
        var cPage:Int = 0
        if scrollView == self.collectionViewLabel {
            pageSide = self.pageSize.width
            offset = scrollView.contentOffset.x
            cPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            
            self.collectionView.setContentOffset(CGPoint(x: (CGFloat(cPage) * self.view.frame.size.width), y:0), animated: true)
        }else{
            pageSide = self.view.frame.size.width
            offset = scrollView.contentOffset.x
            cPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            
            self.collectionViewLabel.setContentOffset(CGPoint(x: (CGFloat(cPage) * self.pageSize.width), y:0), animated: true)
        }
        
        self.currentResult = self.results[cPage]
        let score2dp = (self.currentResult.score * 100).rounded() / 100
        self.ratingLabel.text = String(score2dp)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadEncounterSegue" {
            let destinationVC = segue.destination as! UploadResultsViewController
            destinationVC.selectedImage = sharkUploadImageView.image
        }
    }


}


