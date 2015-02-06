//
//  FindViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class FindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let isLoggedIn:String? = KeychainWrapper.stringForKey("isLoggedIn")
        
        if (isLoggedIn != "1") {
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
        
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

