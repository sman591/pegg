//
//  AuthViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class AuthViewController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let isLoggedIn:String? = KeychainWrapper.stringForKey("isLoggedIn")
        
        if (isLoggedIn == "1") {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func loginButtonAction(sender: UIButton) {
        
        let username:NSString = userField.text as NSString
        let password:NSString = passField.text as NSString
        
        Alamofire.request(.POST, "http://friendlyu.com/pegg/loginUser.php",
            parameters: ["user": username, "pass": password])
            .responseJSON { (_, _, data, error) in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    let success = json["success"]
                    if success {
                        let saveToken: Bool = KeychainWrapper.setString(json["data"]["token"].stringValue, forKey: "token")
                        let loggedIn: Bool = KeychainWrapper.setString("1", forKey: "isLoggedIn")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = json["data"]["message"].stringValue
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
