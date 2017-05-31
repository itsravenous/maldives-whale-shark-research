//
//  SharkProfileTableViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/9/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import AlgoliaSearch
import MapKit

class SharkProfileTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    var sharkImagesCell: SharkImagesTableViewCell?
    var selectedShark: JSONObject?
    let regionRadius: CLLocationDistance = 1000
    var currentPage = 0

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Close navigation gap
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - IBActions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        // image to share
        let image = UIImage(named: "shark1")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    // Split location string
    // Separate into latitude and longitude variables
    // Set Location
    func setLocation(encounterLocation: String) -> MKCoordinateRegion {
        let locationArray = encounterLocation.components(separatedBy: ", ")
        let latitude = Double(locationArray[0])
        let longitude = Double(locationArray[1])
        
        let initialLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        return coordinateRegion
    }
    
    // Convert date from date string and subtract from current date
    func convertDate(encounterDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: encounterDate)
        dateFormatter.dateStyle = .long
        let newDate = dateFormatter.string(from: date!)
        
        return String(describing: newDate)
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let shark = WhaleShark(json: selectedShark!)
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCell", for: indexPath) as! SharkImagesTableViewCell
            sharkImagesCell = cell
            cell.pageControl.numberOfPages = (shark.media?.count)!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! SharkDescriptionTableViewCell
            cell.sharkNameLabel.text = shark.name
            cell.sharkIdLabel.text = shark.id
            if shark.sex == "M" {
                cell.sharkSexImageView.image = UIImage(named: "male-icon")
                cell.sharkSexLineImageView.image = UIImage(named: "male-rectangle")
            } else if shark.sex == "F" {
                cell.sharkSexImageView.image = UIImage(named: "female-icon")
                cell.sharkSexLineImageView.image = UIImage(named: "female-rectangle")
            } else {
                cell.sharkSexImageView.image = UIImage(named: "unknown-icon")
                cell.sharkSexLineImageView.image = UIImage(named: "unknown-rectangle")
            }
            cell.sharkTotalEncountersLabel.text = shark.totalEncounters
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstEncounterCell", for: indexPath) as! SharkFirstEncounterTableViewCell
            cell.firstEncounterDateLabel.text = convertDate(encounterDate: shark.firstDate!)
            cell.firstEncounterLengthLabel.text = shark.firstLength! + " meters"
            cell.firstEncounterSeenByLabel.text = shark.firstContributor
            cell.firstEncounterMapView.setRegion(setLocation(encounterLocation: shark.firstLocation!), animated: false)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastEncounterCell", for: indexPath) as! SharkLastEncounterTableViewCell
            cell.lastEncounterDateLabel.text = convertDate(encounterDate: shark.lastDate!)
            cell.lastEncounterLengthLabel.text = shark.lastLength! + " meters"
            cell.lastEncounterSeenByLabel.text = shark.lastContributor
            cell.lastEncounterMapView.setRegion(setLocation(encounterLocation: shark.lastLocation!), animated: false)
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 375
        case 1: return 270
        case 2: return 573
        default: return 573
            
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharkPictureCell", for: indexPath) as! SharkImageCollectionViewCell
        
        let shark = WhaleShark(json: selectedShark!)
        
        cell.imageView.sd_setImage(with: URL(string: (shark.media![indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))

        print(shark.media?[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        return cell
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let shark = WhaleShark(json: selectedShark!)
        return (shark.media!.count)
    }
    
    // MARK: - ScrollView Delegate Method
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = sharkImagesCell {
            let pageWidth = scrollView.frame.width
            self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            cell.pageControl.currentPage = self.currentPage
        }
    }
}
