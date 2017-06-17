//
//  UploadResultsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/17/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit

class UploadResultsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var sharkImage: UIImageView!
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // MARK: - Properties
    var selectedImage: UIImage!
    var timer = Timer()

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
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
