//
//  FirstViewController.swift
//  AustinForVeteransStartupWeekend
//
//  Created by George Pazdral (work) on 9/29/18.
//  Copyright © 2018 George Pazdral (work). All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class MapkitViewController: UIViewController {
    
    // MARK: - Properties
    var artworks: [Artwork] = []
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
    
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            var viewRegion = MKCoordinateRegion()
            viewRegion.span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
            viewRegion.center = userLocation
            mapView.setRegion(viewRegion, animated: true)
        }
        
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        mapView.showsUserLocation = true
//        var region = MKCoordinateRegion()
//        region.span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7); //Zoom distance
//        let coordinate = CLLocationCoordinate2D(latitude: 30.265212, longitude: -97.756050)
//        region.center = coordinate
//        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        if #available(iOS 11.0, *) {
            mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        
        
        
        
        
        Database.database().reference().child("markers").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snapshots {
                    print("Child: ", child)
                    
                    let snap = child
                    
                    guard let dict = snap.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    
                    let lat = dict["latitude"] as? String
                    let latitude = (lat! as NSString).doubleValue
                    let long = dict["longitude"] as? String
                    let longitude = (long! as NSString).doubleValue
                    let titlez = dict["title"] as? String
                    let snippet = dict["snippet"] as? String
                    
                    
                    let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let artwork = Artwork(title: titlez!, locationName: snippet!, discipline: "Flag", coordinate: position)
                    self.mapView.addAnnotation(artwork)
                    
                }
            }
        })
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            print("heyheyhey")
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted){
            print("Location access was restricted.")
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
            print("User denied access to location. this is da whey.")
            performSegue(withIdentifier: "toOpenSettings", sender: self)
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
            print("Location status not determined. Scrubby.")
            checkLocationAuthorizationStatus()
            
        }
        else{
            print("not getting location")
            // a default pin
        }
        
        
    }
    
    // MARK: - CLLocationManager
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            print("Location status not determined.")
                   performSegue(withIdentifier: "toEnableLoc", sender: self)
        }
    }

    
    // MARK: - Helper methods
    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
//                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
    
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        let validWorks = works.compactMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
}

// MARK: - MKMapViewDelegate
extension MapkitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if view.rightCalloutAccessoryView == control {
            let location = view.annotation as! Artwork
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:
                MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        else {
            
            Database.database().reference().child("markers").queryOrdered(byChild: "title").queryEqual(toValue: view.annotation?.title).observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        print("Child: ", child)
                        
                        
                        let snap = child
                        
                        guard let dict = snap.value as? [String:Any] else {
                            print("Error")
                            return
                        }
                        
                        let lat = dict["url"] as? String
                        
                        
                        
                        
                        print("gotcha!")
                        guard let url = URL(string: lat!) else {
                            return //be safe
                        }
                        
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                
            })
            
            
            
            
        }
    }
    
}

