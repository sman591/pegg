//
//  PeggViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class PeggViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var nav = self.navigationController?.navigationBar
        var color = UIColor(red: 127/255.0, green: 73/255.0, blue: 220/255.0, alpha: 1.0)
        nav?.barTintColor = color
        
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

