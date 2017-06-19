//
//  EditPhotoInformationViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import MapKit

public protocol EditPhotoDelegate: class {
    func informationEdited(_ location: CLLocation?, photoDate: Date?)
}

class EditPhotoInformationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    var location: CLLocation?
    var photoDate: Date?
    public weak var delegate: EditPhotoDelegate? = nil

    // MARK: - Properties
    var newImage: UIImage!
        
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = newImage
        datePicker.setValue(UIColor.white, forKey: "textColor")
        dateButton.setTitleColor(UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1), for: .normal)
        mapView.isHidden = true
        if let date = photoDate{
            datePicker.date = date
        }
        if let loc = location{
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            let region = MKCoordinateRegion(center: loc.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc.coordinate            
            mapView.addAnnotation(annotation)

//            mapView.setCenter(loc.coordinate, animated: true)
        }
        
        let tapPress = UITapGestureRecognizer(target: self, action: #selector(mapTapPress(_:))) // colon needs to pass through info
        tapPress.numberOfTapsRequired = 1 // in seconds
        //add gesture recognition
        mapView.addGestureRecognizer(tapPress)
    }
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
    
    func mapTapPress(_ recognizer: UIGestureRecognizer) {
        
        removeAllAnnotations()
        print("A tap has been detected.")
        
        let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = self.mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
        
        location = CLLocation(latitude: touchedAtCoordinate.latitude, longitude: touchedAtCoordinate.longitude)
                
        let newPin = MKPointAnnotation()
        newPin.coordinate = touchedAtCoordinate
        self.mapView.addAnnotation(newPin)
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
        delegate?.informationEdited(location, photoDate: datePicker.date)
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
