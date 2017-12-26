//
//  ComparisonProgressViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import Firebase
import i3s_swift

class ComparisonProgressViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var comparisonProgressBar: UIProgressView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sharkImage: UIImageView!
    
    // MARK: - Properties
    var selectedImage: UIImage!
    var fgp: FingerPrint!
    var results = [ComparisonResult]()
    var timer = Timer()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        sharkImage.image = selectedImage
        comparisonProgressBar.transform = comparisonProgressBar.transform.scaledBy(x: 1, y: 5)
    }
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Get all fingerprints and compare against each
        var progress: Float = 0.0
        let db = Database.database().reference();
        db.child("fingerprints").observeSingleEvent(of: .value, with: { (snapshot) in
            let fingerprints = snapshot.children.allObjects
            let total = Float(fingerprints.count)
            for rest in fingerprints as! [DataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                let refs = restDict["refs"] as? [[Double]]
                let refsFlat = refs?.reduce([], +)
                let keypoints = restDict["keypoints"] as? [[Double]]
                let keypointsAsQuads = keypoints!
                    .map {Array(repeating: [$0[0], $0[1]], count: 4).reduce([], +)}
                    .reduce([], +)

                let fingerprint = FingerPrint(ref: refsFlat!, data: keypointsAsQuads, nr: keypoints!.count)
                let score: Double = fingerprint.compare(self.fgp)
                let animalId = restDict["animal_id"] as! String
                // TODO: fetch image from URL or figure out how to use Firebase bucket instead
                var result = ComparisonResult(id: animalId, name: "Fernando", score: score, image: "fernando")
                let animalRef = db.child("sharks").child(animalId);
                // "Join" animal to get name
                animalRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let animalName = value?["name"] as? String ?? ""
                    result.name = animalName
                    self.results.append(result)
                    self.comparisonProgressBar.setProgress(progress / total, animated: false)
                    if (progress == total - 1) {
                        self.goToResults()
                    }
                    progress += 1
                })
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
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        // Set up alert prior to cancel
        let alert = UIAlertController(title: "Cancel Comparison", message: "Are you sure you want to stop the comparison?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Stop", style: UIAlertActionStyle.destructive, handler: { (action) in
            self.timer.invalidate()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func goToResults() {
        self.performSegue(withIdentifier: "comparisonToResultsSegue", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comparisonToResultsSegue" {
            let destinationVC = segue.destination as! ComparisonResultsViewController
            destinationVC.selectedImage = sharkImage.image
            destinationVC.results = self.results
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
