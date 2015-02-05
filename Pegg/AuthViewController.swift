//
//  AuthViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Parse

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFObject(className: "Users")
        user.setObject("speakerbug", forKey: "username")
        user.setObject("Henry", forKey: "firstName")
        user.setObject("Saniuk", forKey: "LastName")
        user.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if success != nil {
                NSLog("Object created with id: \(user.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
        
    }

    @IBAction func loginButtonAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
