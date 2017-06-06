//
//  EditPhotoInformationViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import MapKit

class EditPhotoInformationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        dateButton.setTitleColor(UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1), for: .normal)
        mapView.isHidden = true
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
    @IBAction func backButtonPressed(_ sender: UIButton) {

    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func dateButtonPressed(_ sender: UIButton) {
        datePicker.isHidden = false
        mapView.isHidden = true
        dateButton.setTitleColor(UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1), for: .normal)
        locationButton.setTitleColor(UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), for: .normal)
    }

    @IBAction func locationButtonPressed(_ sender: UIButton) {
        datePicker.isHidden = true
        mapView.isHidden = false
        locationButton.setTitleColor(UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1), for: .normal)
        dateButton.setTitleColor(UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), for: .normal)
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
