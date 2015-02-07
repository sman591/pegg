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
    var badges: [String] = []
    var friends: [String] = []
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //Badges
            badgesTable()
        case 1:
            //Friends
            friendsTable()
        case 2:
            //Recent
            friendsTable()
        default:
            break
        }
    }
    
    func badgesTable() {
        items = ["This", "Is", "Badges"]
        tableView.reloadData()
    }
    
    func friendsTable() {
        items = ["This", "Is", "Friends"]
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
            self.points.text = data["points"].stringValue
            let fullName = data["first"].stringValue + " " + data["last"].stringValue
            self.name.text = fullName
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ProfileTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as ProfileTableViewCell
        
        cell.nameLabel?.text = self.items[indexPath.row]
        //cell.detailTextLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}