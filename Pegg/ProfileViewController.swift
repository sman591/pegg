//
//  ProfileViewController.swift
//  Pegg
//
//  Created by Henry Saniuk on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImageView(image: UIImage(named: "headshot"))
        self.profilePictureView = image
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
        self.profilePictureView.clipsToBounds = true;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let token:String! = KeychainWrapper.stringForKey("token")
        
        Alamofire.request(.POST, "http://friendlyu.com/pegg/me.php",
            parameters: ["token": token, "app_id": "test"])
            .responseJSON { (_, _, data, error) in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    let success = json["success"]
                    if success {
                        self.points.text = json["data"]["points"].stringValue
                        let fullName = json["data"]["first"].stringValue + " " + json["data"]["last"].stringValue
                        self.name.text = fullName
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Error"
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
        // Dispose of any resources that can be recreated.
    }
    
    
}