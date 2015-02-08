//
//  ProfileViewController.swift
//  Pegg
//
//  Created by Henry Saniuk on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var editProfile: UIButton!
    
    var items: [String] = []
    var details: [String] = []
    var friends: [String] = []
    var friendsUsernames: [String] = []
    var badges: [String] = []
    var badgesDetails: [String] = []
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //Badges
            badgesTable()
        case 1:
            //Friends
            friendsTable()
        default:
            break
        }
    }
    
    func badgesTable() {
        
        if (badges.count == 0) {
            items = ["You have no badges"]
            details = [":("]
        } else {
        items = badges
        details = badgesDetails
        }
        
        tableView.reloadData()
    }
    
    func friendsTable() {
        
        if (friends.count == 0) {
            items = ["You have no friends"]
            details = [":("]
        } else {
            items = friends
            details = friendsUsernames
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        badgesTable()
        
        let image = UIImageView(image: UIImage(named: "headshot"))
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        editProfile.layer.cornerRadius = 5
        
        PeggAPI.loadProfile { data in
            self.friends = []
            self.badges = []
            self.badgesDetails = []
            self.badges = []
            self.points.text = data["points"].stringValue
            let fullName = data["first"].stringValue + " " + data["last"].stringValue
            self.name.text = fullName
            
            for (itemIndex: String, item: JSON) in data["friends"] {
                self.friends.append(item["first"].stringValue + " " + item["last"].stringValue)
                self.friendsUsernames.append(item["username"].stringValue)
            }
            
            for (itemIndex: String, item: JSON) in data["badges"] {
                self.badges.append(item["name"].stringValue)
                self.badgesDetails.append(item["details"].stringValue)
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ProfileTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as ProfileTableViewCell
        
        cell.nameLabel?.text = self.items[indexPath.row]
        cell.descriptionLabel?.text = self.details[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}