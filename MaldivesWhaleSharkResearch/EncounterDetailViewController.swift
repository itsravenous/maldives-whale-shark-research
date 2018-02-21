//
//  EncounterViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 4/30/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import SDWebImage

class EncounterDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var encounterDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var contributorNameLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    var selectedEncounter: Encounter?
    var currentPage = 0
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationLabel.adjustsFontSizeToFitWidth = true
        self.encounterDateLabel.adjustsFontSizeToFitWidth = true
        
        self.title = selectedEncounter?.sharkName
        self.encounterDateLabel.text = selectedEncounter?.date
        self.locationLabel.text = selectedEncounter?.locationName
        self.lengthLabel.text = selectedEncounter!.length == "Unknown" ? String(describing: selectedEncounter!.length) : String(describing: selectedEncounter!.length) + "m"
        self.contributorNameLabel.text = selectedEncounter?.contributorName
        self.contributorImageView.sd_setImage(with: URL(string: (selectedEncounter?.contributorImage)!))
        
        self.pageControl.numberOfPages = (selectedEncounter?.images.count)!
        
    }
    
    // MARK: - IBActions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let url = selectedEncounter?.images[0].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let imageFromCache = SDImageCache.shared().imageFromCache(forKey: url!)
        if (imageFromCache != nil) {
            presentShareImage(imageToShare: [ imageFromCache! ])
        } else {
            SDWebImageDownloader.shared().downloadImage(with: URL(string: url!), options: [], progress: nil) { (image: UIImage?, data: Data?, error: Error?, finished: Bool) in
                if (!finished || error != nil) { return }
                // set up activity view controller
                self.presentShareImage(imageToShare: [ image! ])
            }
        }
    }

    func presentShareImage(imageToShare: [UIImage]) {
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedEncounter?.images.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! EncounterCollectionViewCell
        
        cell.imageView.sd_setImage(with: URL(string: (selectedEncounter?.images[indexPath.row])!))
        
        return cell
    }
    
    // MARK: - ScrollView Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = self.currentPage
    }

}
