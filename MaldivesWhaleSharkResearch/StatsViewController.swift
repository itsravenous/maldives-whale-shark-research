//
//  StatsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/3/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import BWWalkthrough
import Photos

class StatsViewController: UIViewController, BWWalkthroughViewControllerDelegate, FusumaDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var allTimeView: UIView!
    
    // MARK: - Properties
    var uploadWalkthrough:BWWalkthroughViewController!
    
    // MARK: - Actions
    @IBAction func uploadImageButtonPressed(_ sender: UIBarButtonItem) {
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "uploadInstructions") {
            
            showInstructions()
            
            userDefaults.set(true, forKey: "uploadInstructions")
            userDefaults.synchronize()
            
            //then showUploadPicture()
        } else {
            showUploadPicture()
        }
        
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.titles = ["Week","Month","All-time"]
        segmentedControl.titleFont = UIFont(name: "MuseoSans-500", size: 16.0)!
        segmentedControl.selectedTitleFont = UIFont(name: "MuseoSans-500", size: 16.0)!
        segmentedControl.alwaysAnnouncesValue = true
        segmentedControl.announcesValueImmediately = false
        segmentedControl.bouncesOnChange = true
        segmentedControl.panningDisabled = true
        segmentedControl.addTarget(self, action: #selector(StatsViewController.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)

        
        let customSubview = UIView(frame: CGRect(x: 0, y: 40, width: 40, height: 4.0))
        customSubview.backgroundColor = .blue
        customSubview.layer.cornerRadius = 2.0
        customSubview.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        segmentedControl.addSubviewToIndicator(customSubview)
//        view.addSubview(indicatorControl)
        
        // Hide the 2 other segmeneted views
        monthView.isHidden = true
        allTimeView.isHidden = true

    }
    
    // MARK: - Functions

    func showInstructions() {
        
        let stb = UIStoryboard(name: "UploadWalkthrough", bundle: nil)
        uploadWalkthrough = stb.instantiateViewController(withIdentifier: "container") as! BWWalkthroughViewController
        
        // Get view controllers and build the walkthrough
        let page_one = stb.instantiateViewController(withIdentifier: "page_1")
        let page_two = stb.instantiateViewController(withIdentifier: "page_2")
        let page_three = stb.instantiateViewController(withIdentifier: "page_3")
        let page_four = stb.instantiateViewController(withIdentifier: "page_4")
        
        // Attach the pages to the master
        uploadWalkthrough.delegate = self
        uploadWalkthrough.add(viewController:page_one)
        uploadWalkthrough.add(viewController:page_two)
        uploadWalkthrough.add(viewController:page_three)
        uploadWalkthrough.add(viewController:page_four)
        
        self.present(uploadWalkthrough, animated: true, completion: nil)
        
    }
    
    func showUploadPicture() {
        print("Upload Picture Bro")
        let fusuma = FusumaViewController()
        
//        fusumaCropImage = false
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        fusuma.hasVideo = false
        fusumaTintColor = UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1)
        fusumaBackgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1)
        self.present(fusuma, animated: true, completion: nil)
    }
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
        if (self.uploadWalkthrough.numberOfPages - 1) == pageNumber {
            self.uploadWalkthrough.closeButton?.isHidden = false
        } else {
            self.uploadWalkthrough.closeButton?.isHidden = true
        }
    }
    
    
    // MARK: FusumaDelegate Protocol
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        print("Image selected: \(image)")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    func fusumaWillClosed() {
        
        print("Called when the close button is pressed")
    }

    // MARK: - Segmented Control Action handlers
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 {
            print("Week")
            weekView.isHidden = false
            monthView.isHidden = true
            allTimeView.isHidden = true
        }
        else if sender.index == 1 {
            print("Month")
            weekView.isHidden = true
            monthView.isHidden = false
            allTimeView.isHidden = true
        } else {
            print("All-time")
            weekView.isHidden = true
            monthView.isHidden = true
            allTimeView.isHidden = false
        }
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
