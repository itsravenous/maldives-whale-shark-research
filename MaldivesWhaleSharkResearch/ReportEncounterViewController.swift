//
//  ReportEncounterViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import i3s_swift

class ReportEncounterViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sharkImage: UIImageView!
    @IBOutlet weak var refPointTitle: UILabel!
    @IBOutlet weak var refPointInstructions: UILabel!
    @IBOutlet weak var refPointImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    // MARK: - Properties
    var refs1 :[Double] = []
    var spots1 :[Double] = []
    var counter = 0
    var pageCounter = 1
    var selectedImage: UIImage!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        sharkImage.image = selectedImage
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MuseoSans-500", size: 17)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        self.containerView.isHidden = true
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        scrollView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        
        self.sharkImage.isUserInteractionEnabled = true
        self.sharkImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setZoomScale() {
        
        var minZoom = min(scrollView.bounds.size.width / sharkImage!.bounds.size.width, scrollView.bounds.size.height / sharkImage!.bounds.size.height);
        
        if (minZoom > 1.0) {
            minZoom = 1.0;
        }
        
        scrollView.minimumZoomScale = minZoom;
        scrollView.zoomScale = minZoom;
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
    
    // MARK: - Scroll View
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return sharkImage
    }
    
    // MARK: - Functions
    func tapAction(sender: UITapGestureRecognizer) {
        // increase counter with +1 for each click
        counter += 1
        pageCounter += 1
        
        // Get points for the UIImageView
        let touchPoint = sender.location(in: self.sharkImage)
        let touchPointValue = [Double(touchPoint.x), Double(touchPoint.y)]
        
        // Get points from the image itself
        //        let z1 = touchPoint.x * (sharkImage.image?.size.width)! / sharkImage.frame.width
        //        let z2 = touchPoint.y * (sharkImage.image?.size.height)! / sharkImage.frame.height
        //        print("Touched point (\(z1), \(z2)")
        
        // Add pin to center of touched point
        let pin = UIImageView(frame: CGRect(x: touchPoint.x - 3, y: touchPoint.y - 3, width:6, height:6))
        
        // Add reference and spots to arrays
        if counter <= 3 { // first 3 times add red
            pin.image = UIImage(named: "photo-pin-red")
            sharkImage.addSubview(pin)
            refs1 += touchPointValue
            print("Ref array: \(refs1)")
        } else if counter <= 23 { // next 14 - 20 add green
            pin.image = UIImage(named: "photo-pin-green")
            sharkImage.addSubview(pin)
            spots1 += touchPointValue
            print("Spot array: \(spots1)")
        } else if counter > 23 {
            // Alert the user to run a comparison
            let alert = UIAlertController(title: "Enough Spots Recorded", message: "You are ready to run a comparison.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        // Change Footer Section
        if pageCounter == 1 {
            refPointTitle.text = "First Reference Point"
            refPointInstructions.text = "Add the 1st reference point (top of the 5th gill slit)"
            refPointImage.image = UIImage(named:"firstRefPoint")
            pageControl.currentPage = 0
        } else if pageCounter == 2 {
            refPointTitle.text = "Second Reference Point"
            refPointInstructions.text = "Add the 2nd reference point (edge of the pectoral fin)"
            refPointImage.image = UIImage(named:"secondRefPoint")
            pageControl.currentPage = 1
        } else if pageCounter == 3 {
            refPointTitle.text = "Third Reference Point"
            refPointInstructions.text = "Add the 3rd reference point (bottom of the 5th gill slit)"
            refPointImage.image = UIImage(named:"thirdRefPoint")
            pageControl.currentPage = 2
        } else {
            refPointTitle.text = "Spot Annotations"
            refPointInstructions.text = "Add 14 - 20 spots in the reference area on the shark"
            refPointImage.image = UIImage(named:"spotAnnotations")
            pageControl.currentPage = 3
        }
        
        // Enable done (comparison) button after 14 spot annotations
        if counter >= 17 {
            doneButton.isEnabled = true
        }
        
    }
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print("Done button pushed: Run Comparison")
        self.containerView.isHidden = false
        // Create FingerPrint from marked refs and spots
        let fgp = FingerPrint(ref: refs1, data: spots1, nr: spots1.count / 8)

        // Create dummy comparison fingerprint
        let refs2 : [Double] = [ 0.0, 0.0, 100.0, 100.0, 0.0, 100.0 ]
        let spots2 : [Double] = [
            15.0, 15.0, 15.0, 15.0, 15.0, 15.0, 15.0, 15.0,
            20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
            37.0, 37.0, 37.0, 37.0, 37.0, 37.0, 37.0, 37.0,
            40.0, 40.0, 40.0, 40.0, 40.0, 40.0, 40.0, 40.0
        ]

        let fgp2 = FingerPrint(ref: refs2, data: spots2, nr: 4)
        print(fgp.compare(fgp2))
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportToComparisonSegue" {
            let destinationVC = segue.destination as! ComparisonProgressViewController
            destinationVC.selectedImage = self.sharkImage.image
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
