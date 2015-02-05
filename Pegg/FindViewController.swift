//
//  FindViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class FindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLoggedIn:String? = KeychainWrapper.stringForKey("isLoggedIn")
        
        if (isLoggedIn != "1") {
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
        
        var nav = self.navigationController?.navigationBar
        var color = UIColor(red: 127/255.0, green: 73/255.0, blue: 220/255.0, alpha: 1.0)
        nav?.barTintColor = color
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

