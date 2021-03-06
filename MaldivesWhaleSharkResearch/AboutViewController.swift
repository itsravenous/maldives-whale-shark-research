//
//  AboutViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/2/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class AboutViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var mwsrpView: UIView!
    @IBOutlet weak var bfnView: UIView!
    @IBOutlet weak var critterView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Add the segmented control
        segmentedControl.titles = ["MWSRP","BFN","CRITTER"]
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
        bfnView.isHidden = true
        critterView.isHidden = true

    }
    
    // MARK: - Segmented Control Action handlers
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 {
            print("MWSRP")
            mwsrpView.isHidden = false
            bfnView.isHidden = true
            critterView.isHidden = true
        }
        else if sender.index == 1 {
            print("BFN")
            mwsrpView.isHidden = true
            bfnView.isHidden = false
            critterView.isHidden = true
        } else {
            print("Critter")
            mwsrpView.isHidden = true
            bfnView.isHidden = true
            critterView.isHidden = false
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
