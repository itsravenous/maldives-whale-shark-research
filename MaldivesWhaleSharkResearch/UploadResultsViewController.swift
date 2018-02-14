//
//  UploadResultsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/17/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import FirebaseStorage
import i3s_swift

class UploadResultsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var sharkImage: UIImageView!
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // MARK: - Properties
    var selectedImage: UIImage!
    var fgp: FingerPrint!
    var location: CLLocation!
    var date: Date!
    var timer = Timer()
    var annotationRefs :[Double] = []
    var annotationKeypoints :[[Double]] = []
    var animalId: String!
    var side: AnimalSide!

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        sharkImage.image = selectedImage
        uploadProgressBar.transform = uploadProgressBar.transform.scaledBy(x: 1, y: 5)
    }
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        
        UIView.animate(withDuration: 5) {
            self.uploadProgressBar.setProgress(1.0, animated: true)
        }
        
        // Create encounter
        let db = Database.database().reference()
        let animalRef = db.child("sharks").child(animalId)
        
        let ref = db.child("encounters").childByAutoId()
        
        animalRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let animalName = value?["name"] as? String ?? ""

            let annotation: [String: Any] = [
                "image": "",
                "image_thumb": "",
                "side": String(describing: self.side),
                "refs": self.annotationRefs,
                "keypoints": self.annotationKeypoints,
            ]
            let encounter: [String: Any] = [
                "behaviour": "",
                "contributor": "",
                "contributor_image": "",
                "distinguishing_features": "",
                "length_est": "",
                "location_name": "",
                "location_tile": "",
                "shark_id": self.animalId,
                "shark_name": animalName,
                "trip_date": ISO8601DateFormatter().string(from: self.date),
                "user_id": "",
                "annotation": annotation,
                "easting_approx": self.location != nil ? self.location.coordinate.longitude : "",
                "northing_approx": self.location != nil ? self.location.coordinate.latitude : "",
            ]
            ref.setValue(encounter)
            
            // TODO upload selectedImage, listen for success and update encounter record with URL (and thumb URL)
            
            print(ref)
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let uniqueFileName = UUID().uuidString
            let photoRef = storageRef.child(uniqueFileName)
            let data = UIImageJPEGRepresentation(self.selectedImage, 0.8)!
            photoRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                ref.child("media").childByAutoId().child("url").setValue(metadata.downloadURLs?[0].absoluteString)
            }
        })
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
    func timerAction() {
        self.performSegue(withIdentifier: "uploadToConfirmationSegue", sender: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadToConfirmationSegue" {
            let destinationVC = segue.destination as! UploadConfirmationViewController
            destinationVC.selectedImage = sharkImage.image
            destinationVC.animalId = animalId
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
