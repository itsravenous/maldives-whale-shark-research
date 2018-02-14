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
import BWWalkthrough

class MapViewController: UIViewController, BWWalkthroughViewControllerDelegate, FusumaDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let manager = ClusterManager()
    var encounters : [Encounter] = []
    let annotations: [Annotation] = []
    let encounterDetailVC = EncounterDetailViewController()
    let regionRadius: CLLocationDistance = 1000
    var uploadWalkthrough:BWWalkthroughViewController!
    
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
                    let mediaDict = restDict["media"] as? [String: [String: Any]]
                    encounter.images = mediaDict?.values.flatMap {$0["url"] as? String} ?? []
                } else {
                    encounter.images = ["https://mwsrp-network.org/uploads/encounters/thumbs/5346/P5145120.JPG"]
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
    // Show initial walkthrough for first time user
    func showWalkthrough() {
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "container") as! BWWalkthroughViewController
        
        // Get view controllers and build the walkthrough
        let page_one = stb.instantiateViewController(withIdentifier: "page_1")
        let page_two = stb.instantiateViewController(withIdentifier: "page_2")
        let page_three = stb.instantiateViewController(withIdentifier: "page_3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    // Show instructions for image upload
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
    
    // Present image picker for photo upload
    func showUploadPicture() {
        let fusuma = FusumaViewController()
        
        fusumaCropImage = true
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        fusuma.hasVideo = false
        fusumaTintColor = UIColor(red: 80.0/255.0, green: 191.0/255.0, blue: 195.0/255.0, alpha: 1)
        fusumaBackgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1)
        self.present(fusuma, animated: true, completion: nil)
    }
    
    // MARK: - FusumaDelegate Protocol
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        let stb = UIStoryboard(name: "UploadPicture", bundle: nil)
        let photoInfo = stb.instantiateViewController(withIdentifier: "photoInfo") as! PhotoInformationViewController
        
        print("Image selected: \(image)")
        
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
        
        self.dismiss(animated: true, completion: nil)
        self.present(photoInfo, animated: true) {
            photoInfo.imageView.image = image
            photoInfo.photoDate = metaData.creationDate
            photoInfo.location = metaData.location
        }
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
    
    // MARK: - Actions
    @IBAction func uploadImageButtonPressed(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        // Show photo upload
        if !userDefaults.bool(forKey: "uploadInstructions") {
            showInstructions()
            userDefaults.set(true, forKey: "uploadInstructions")
            userDefaults.synchronize()
        } else {
            showUploadPicture()
        }
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

