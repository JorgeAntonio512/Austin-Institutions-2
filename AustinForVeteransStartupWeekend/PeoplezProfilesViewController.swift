//
//  PeoplezProfilesViewController.swift
//  AustinForVeteransStartupWeekend
//
//  Created by George Pazdral (work) on 11/8/18.
//  Copyright © 2018 George Pazdral (work). All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PeoplezProfilesViewController: UIViewController {
    var blurbz = ""
    @IBOutlet weak var blurbb: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurbb.text = blurbz
        
    }
    
}
