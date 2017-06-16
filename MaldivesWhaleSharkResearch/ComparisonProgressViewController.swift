//
//  ComparisonProgressViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class ComparisonProgressViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var comparisonProgressBar: UIProgressView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sharkImage: UIImageView!
    
    // MARK: - Properties
    var selectedImage: UIImage!
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
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        
        UIView.animate(withDuration: 5) { 
            self.comparisonProgressBar.setProgress(1.0, animated: true)
        }
    
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
    func timerAction() {
        self.performSegue(withIdentifier: "comparisonToResultsSegue", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comparisonToResultsSegue" {
            let destinationVC = segue.destination as! ComparisonResultsViewController
            destinationVC.selectedImage = sharkImage.image
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
