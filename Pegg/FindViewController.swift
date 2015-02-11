//
//  FindViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class FindViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var challenges = [Challenge]()
    var hasAppearedWithChallenges = false
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            let alertVC = UIAlertController(title: "Error", message: "Location services are not enabled. Please enable them in your settings.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
            alertVC.addAction(okAction)
            presentViewController(alertVC, animated: true, completion: nil)
        }
        
        if (!AuthenticationManager.isLoggedIn()) {
            (UIApplication.sharedApplication().delegate as AppDelegate).didLogOut()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        hasAppearedWithChallenges = false
        if self.challenges.count == 0 {
            self.challenges = [Challenge(name: "Loading...", distance: "", id: "", timestamp: "", details: "", lat: 0, lng: 0)]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as ChallengeTableViewCell
        let challenge = self.challenges[indexPath.row]
        
        cell.nameLabel.text = challenge.name
        cell.dateLabel.text = challenge.timestamp
        cell.distanceLabel.text = challenge.distance
        cell.imagePreview.image = challenge.image
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChallenge" {
            let challengeDetailViewController = segue.destinationViewController as ChallengeViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            challengeDetailViewController.challenge = self.challenges[indexPath.row]
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if !hasAppearedWithChallenges {
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            PeggAPI.getChallenges(String(format:"%f", coord.latitude), lng: String(format:"%f", coord.longitude), completion: { json in
                    self.hasAppearedWithChallenges = true
                
                    self.challenges = []
                
                    for (index, pegg) in json["peggs"] {
                        println(pegg)
                        self.challenges.append(Challenge(
                            name: pegg["name"].stringValue,
                            distance: pegg["distance"].stringValue,
                            id: pegg["id"].stringValue,
                            timestamp: pegg["timestamp"].stringValue,
                            details: pegg["details"].stringValue,
                            lat: pegg["lat"].doubleValue,
                            lng: pegg["lng"].doubleValue
                            ))
                    }
                
                    if self.challenges.count == 0 {
                        self.challenges = [Challenge(name: "No challenges", distance: "", id: "", timestamp: "", details: "", lat: 0.0, lng: 0.0)]
                    }
                
                    self.tableView.reloadData()
                }, failure: { json in
                    // do nothing, wait for next location update
                }
            )
        }
    }
    
}

