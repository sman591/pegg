//
//  SettingsViewController.swift
//  Pegg
//
//  Created by Henry Saniuk on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = tableView.indexPathForSelectedRow()?.row;
        let section = tableView.indexPathForSelectedRow()?.section;
        if (row == 0 && section == 0) {
            //logout button
            let saveToken: Bool = KeychainWrapper.setString("", forKey: "token")
            let loggedIn: Bool = KeychainWrapper.setString("0", forKey: "isLoggedIn")
            self.performSegueWithIdentifier("logout", sender: self)
        }
        if (row == 0 && section == 1) {
            //about button
            self.performSegueWithIdentifier("about", sender: self)
        }
        if (row == 1 && section == 1) {
            //credits button
            self.performSegueWithIdentifier("credits", sender: self)
        }
        if (row == 2 && section == 1) {
            //contact button
            let email = "henry@henrysaniuk.com"
            let url = NSURL(string: "mailto:\(email)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let token:String! = KeychainWrapper.stringForKey("token")
        
        //check if user's token is still active
        
        Alamofire.request(.POST, "http://friendlyu.com/pegg/activeToken.php",
            parameters: ["token": token])
            .responseJSON { (_, _, data, error) in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    let success = json["success"]
                    if !success {
                        
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Error"
                        alertView.message = "There was an error validating your login. Please login again."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                        let saveToken: Bool = KeychainWrapper.setString("", forKey: "token")
                        let loggedIn: Bool = KeychainWrapper.setString("0", forKey: "isLoggedIn")
                        
                        self.performSegueWithIdentifier("logout", sender: self)
                        
                    }
                }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

