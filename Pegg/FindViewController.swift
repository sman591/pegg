//
//  FindViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftyJSON

class FindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (!AuthenticationManager.isLoggedIn()) {
            (UIApplication.sharedApplication().delegate as AppDelegate).didLogOut()
        }
    }
    
}

