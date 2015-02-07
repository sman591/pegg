//
//  ProfileViewController.swift
//  Pegg
//
//  Created by Henry Saniuk on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var items: [String] = []
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
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
        self.profilePictureView = image
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
        self.profilePictureView.clipsToBounds = true;
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let token:String! = KeychainWrapper.stringForKey("token")
        
        Alamofire.request(.POST, "http://friendlyu.com/pegg/me.php",
            parameters: ["token": token, "app_id": "test"])
            .responseJSON { (_, _, data, error) in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    let success = json["success"]
                    if success {
                        self.points.text = json["data"]["points"].stringValue
                        let fullName = json["data"]["first"].stringValue + " " + json["data"]["last"].stringValue
                        self.name.text = fullName
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Error"
                        alertView.message = json["data"]["message"].stringValue
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
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