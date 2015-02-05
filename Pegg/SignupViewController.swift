//
//  SignupViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class SignupController: UIViewController {
    
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var lastField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToLogin(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func signupAction(sender: UIButton) {
        
        let username:NSString = userField.text as NSString
        let first_name:NSString = firstField.text as NSString
        let last_name:NSString = lastField.text as NSString
        let email:NSString = emailField.text as NSString
        let password:NSString = passField.text as NSString
        
        Alamofire.request(.POST, "http://friendlyu.com/pegg/addUser.php",
            parameters: ["user": username, "pass": password, "first": first_name, "last": last_name, "email": email])
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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
