//
//  StatsViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/3/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class StatsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    
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
        

    }

    // MARK: - Action handlers
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            print("Week")
            view.backgroundColor = .white
        }
        else if sender.index == 1 {
            print("Month")
            view.backgroundColor = .darkGray
        } else {
            print("All-time")
            view.backgroundColor = .blue
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
