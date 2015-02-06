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
    var clicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
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
                    if success == true {
                        let saveToken: Bool = KeychainWrapper.setString(json["data"]["token"].stringValue, forKey: "token")
                        let loggedIn: Bool = KeychainWrapper.setString("1", forKey: "isLoggedIn")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign In Failed!"
                        alertView.message = json["message"].stringValue
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if !clicked {
            self.view.frame.origin.y -= 175
            clicked = true
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if clicked {
            self.view.frame.origin.y += 175
            clicked = false
        }
        
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
