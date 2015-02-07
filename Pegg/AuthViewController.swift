//
//  AuthViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuthViewController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    var clicked = false
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.layer.cornerRadius = 5
        signup.layer.cornerRadius = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (AuthenticationManager.isLoggedIn()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func loginButtonAction(sender: UIButton) {
        
        let username = userField.text
        let password = passField.text
        
        PeggAPI.sharedInstance.authenticate(username, password: password, completion: { json in
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: { error, message in
                let alertView = UIAlertView()
                alertView.title = "Sign In Failed!"
                alertView.message = message
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            })
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
