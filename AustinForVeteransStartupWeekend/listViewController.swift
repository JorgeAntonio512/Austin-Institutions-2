//
//  listViewController.swift
//  AustinForVeteransStartupWeekend
//
//  Created by George Pazdral (work) on 11/8/18.
//  Copyright © 2018 George Pazdral (work). All rights reserved.
//

import Foundation
import UIKit
import Firebase

class listViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var tableView: UITableView!
    
    var listArray = [ [String: Any] ]()
    var blurb:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        //filteredData = usersArray
        tableView.delegate = self
        tableView.dataSource = self
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        
        
        
        
        
        let ref = Database.database().reference().child("markers").queryOrdered(byChild: "title")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as? [String:AnyObject] // the value is a dict
                    
                    let key = snap.key
                    self.listArray.append(dict!)
                    print(self.listArray)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    
   
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.separatorInset = .zero
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = #imageLiteral(resourceName: "notthere")
        let userDict = self.listArray[indexPath.row]
        
        
        let url = URL(string: userDict["profileImageURL"] as! String)
        let imagur = #imageLiteral(resourceName: "notthere")
        cell.imageView?.kf.setImage(with: url, placeholder: imagur, completionHandler: {
            (image, error, cacheType, imageUrl) in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
            }
            // image: Image? `nil` means failed
            // error: NSError? non-`nil` means failed
            // cacheType: CacheType
            //                  .none - Just downloaded
            //                  .memory - Got from memory cache
            //                  .disk - Got from disk cache
            // imageUrl: URL of the image
        })
        
        
        
        
        
        cell.textLabel?.text = userDict["title"] as? String
        cell.detailTextLabel?.text = userDict["snippet"] as? String
        
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
        } else {
            // Filter the results
            // filteredCakes = usersArray.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.listArray[indexPath.row]
       
        blurb = dict["blurb"] as? String
//        yourRelStatus = dict["status"] as? String
//        yourGender = dict["gender"] as? String
//        yourHeight = dict["height"] as? String
//        yourZip = dict["city"] as? String
//        yourAbout = dict["about"] as? String
//        yourProPic = dict["profileImageURL"] as? String
//        let islandRef = Storage.storage().reference(forURL: yourProPic!)
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//            } else {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
//
//                let user = User.init(name: self.yourValue as! String, email: self.yourHeight as! String, id: self.keyzy!, profilePic: image!)
//                self.selectedUser = user
                self.performSegue(withIdentifier: "toPeoplesProfiles", sender: self)
//
//            }
//
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toPeoplesProfiles") {
            let vc = segue.destination as! PeoplezProfilesViewController
            vc.blurbz = blurb!
            
        }
    }
    
    
    
}
