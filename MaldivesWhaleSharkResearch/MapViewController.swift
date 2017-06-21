//
//  MapViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let manager = ClusterManager()
    var encounters : [Encounter] = []
    let annotations: [Annotation] = []
    let encounterDetailVC = EncounterDetailViewController()
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate
        mapView.delegate = self
        
        // Set the back bar title to blank after segue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // When zoom level is quite close to the pins, disable clustering in order to show individual pins and allow the user to interact with them via callouts.
        manager.zoomLevel = 17
        
        // set initial location in Dhigurah
        let initialLocation = CLLocation(latitude: 3.531172, longitude: 72.926768)
        centerMapOnLocation(location: initialLocation)
        
        // Firebase tableview data
        Database.database().reference().child("encounters").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get the last year's worth of encounters
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                
                let encounter = Encounter()
                encounter.sharkName = (restDict["shark_name"] as? String)!
                encounter.date = (restDict["trip_date"] as? String)!
                encounter.sharkID = (restDict["shark_id"] as? String)!
                encounter.contributorName = (restDict["contributor"] as? String)!
                encounter.contributorImage = (restDict["contributor_image"] as? String)!
                
                // Length
                if restDict["length_est"] != nil {
                    encounter.length = (restDict["length_est"] as? String)!
                } else {
                    encounter.length = "Unknown"
                }
                // Location
                if restDict["location_name"] != nil {
                    encounter.locationName = (restDict["location_name"] as? String)!
                } else {
                    encounter.locationName = "Unknown"
                }
                // Northing default to 4.0
                if restDict["northing"] != nil {
                    encounter.latitude = (restDict["northing"] as? String)!
                } else {
                    encounter.latitude = "4.0"
                }
                // Easting default to 72.0
                if restDict["easting"] != nil {
                    encounter.longitude = (restDict["easting"] as? String)!
                } else {
                    encounter.longitude = "72.0"
                }
                // Media
                if restDict["media"] != nil {
                    let mediaDict = restDict["media"] as! [[String:Any]]
                    encounter.images = mediaDict.flatMap { $0["thumb_url"] as? String }
                } else {
                    encounter.images = ["http://banqlkcn.baria-vungtau.gov.vn/article_summary-portlet/images/default_small_image.jpg"]
                }

                self.encounters.append(encounter)
            }
            self.addAnnotationsToMap()
        })
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            for item in self.mapView.selectedAnnotations {
                self.mapView.deselectAnnotation(item, animated: false)
            }
        }
    }
    
    // MARK: - Functions
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 25.0, regionRadius * 25.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func addAnnotationsToMap() {
        let annotations: [Annotation] = encounters.map { encounter in
            let lat = Double(encounter.latitude)
            let long = Double(encounter.longitude)
            let annotation = Annotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
            annotation.type = .color(color, radius: 25)
            annotation.ID = encounter.sharkID
            return annotation
        }
        manager.add(annotations)
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToEncounterSegue" {
            let destination = segue.destination as! EncounterDetailViewController
            destination.selectedEncounter = sender as! Encounter?
        }
    }
    
}


// MARK: - Map View Extension
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let color = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        if let annotation = annotation as? ClusterAnnotation {
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                if let annotation = annotation.annotations.first as? Annotation, let type = annotation.type {
                    view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: type, borderColor: .white)
                } else {
                    view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: .color(color, radius: 25))
                }
            } else {
                view?.annotation = annotation
            }
            return view
        } else {
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                if #available(iOS 9.0, *) {
                    view?.pinTintColor = color
                } else {
                    view?.pinColor = .green
                }
            } else {
                view?.annotation = annotation
            }
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            mapView.removeAnnotations(mapView.annotations)
            
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            manager.reload(mapView, visibleMapRect: zoomRect)
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else {
            // pass the encounter data
            let annotate = annotation as! Annotation
            if let sharkID = annotate.ID {
                for encounter in self.encounters {
                    if encounter.sharkID == sharkID {
                        performSegue(withIdentifier: "mapToEncounterSegue", sender: encounter)
                        break
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if (view.isKind(of: ClusterAnnotation.self))
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
        
        if (view.isKind(of: Annotation.self))
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
}

extension UIImage {
    
    func filled(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

class BorderedClusterAnnotationView: ClusterAnnotationView {
    var borderColor: UIColor?
    
    convenience init(annotation: MKAnnotation?, reuseIdentifier: String?, type: ClusterAnnotationType, borderColor: UIColor) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier, type: type)
        self.borderColor = borderColor
    }
    
    override func configure() {
        super.configure()
        
        switch type {
        case .image:
            break
        case .color:
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = 2
        }
    }
}

