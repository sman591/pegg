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
    
    var friends = [Friend]()
    var badges = [Badge]()
    var currentTableView = "badges"
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //Badges
            currentTableView = "badges"
        case 1:
            //Friends
            currentTableView = "friends"
        default:
            break
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImageView(image: UIImage(named: "headshot"))
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        editProfile.layer.cornerRadius = 5
        
        PeggAPI.loadProfile { data in
            self.friends = []
            self.badges = []
            self.badges = []
            self.points.text = data["points"].stringValue
            let fullName = data["first"].stringValue + " " + data["last"].stringValue
            self.name.text = fullName
            
            for (itemIndex: String, item: JSON) in data["friends"] {
                self.friends.append(Friend(
                    username: item["username"].stringValue,
                    first: item["first"].stringValue,
                    last: item["last"].stringValue
                ))
            }
            
            if (self.friends.count == 0) {
                self.friends.append(Friend(username: ":(", first: "You have no friends", last: ""))
            }

            for (itemIndex: String, item: JSON) in data["badges"] {
                self.badges.append(Badge(
                    name: item["name"].stringValue,
                    details: item["details"].stringValue
                ))
            }
            
            if (self.badges.count == 0) {
                self.badges.append(Badge(name: "You have no badges", details: ":("))
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentTableView == "badges") {
            return self.badges.count
        }
        else {
            return self.friends.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UserTableViewCell
        
        if (currentTableView == "badges") {
            cell.nameLabel?.text = self.badges[indexPath.row].name
            cell.descriptionLabel?.text = self.badges[indexPath.row].details
        }
        else {
            cell.nameLabel?.text = self.friends[indexPath.row].fullName()
            cell.descriptionLabel?.text = self.friends[indexPath.row].username
        }
        
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