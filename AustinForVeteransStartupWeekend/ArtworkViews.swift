//
//  ArtworkViews.swift
//  AustinForVeteransStartupWeekend
//
//  Created by George Pazdral (work) on 9/29/18.
//  Copyright © 2018 George Pazdral (work). All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class ArtworkMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = artwork.markerTintColor
            if let imageName = artwork.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }
    
}

class ArtworkView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = artwork.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
    
}
