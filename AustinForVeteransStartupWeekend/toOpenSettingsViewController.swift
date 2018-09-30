//
//  toOpenSettingsViewController.swift
//  AustinForVeteransStartupWeekend
//
//  Created by George Pazdral (work) on 9/29/18.
//  Copyright © 2018 George Pazdral (work). All rights reserved.
//

import Foundation
import UIKit
import MapKit

class toOpenSettingsViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        let path = UIApplication.openSettingsURLString
        if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.openURL(settingsURL)
        }
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            DispatchQueue.main.async {
                // Update UI
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted){
            performSegue(withIdentifier: "awayFromOpenSetting", sender: self)
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
            performSegue(withIdentifier: "awayFromOpenSetting", sender: self)
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
        }
        else{
            print("not getting location")
            // a default pin
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "awayFromOpenSetting"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
                tabVC.navigationItem.hidesBackButton = true;
                tabVC.navigationController?.isNavigationBarHidden = true
            }
        }
    }
}