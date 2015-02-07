//
//  SignupViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignupController: UIViewController {

    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var lastField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    var clicked = false

    @IBOutlet weak var signup: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        signup.layer.cornerRadius = 5

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func backToLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func signupAction(sender: UIButton) {

        let username = userField.text
        let first = firstField.text
        let last = lastField.text
        let email = emailField.text
        let password  = passField.text
        
        PeggAPI.signUp(first, last: last, email: email, username: username, password: password, completion: { json in
            self.dismissViewControllerAnimated(true, completion: nil)
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
