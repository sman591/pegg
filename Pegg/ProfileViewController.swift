//
//  ProfileViewController.swift
//  Pegg
//
//  Created by Henry Saniuk on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        var color = UIColor(red: 127/255.0, green: 73/255.0, blue: 220/255.0, alpha: 1.0)
        nav?.barTintColor = color
        
        let image = UIImageView(image: UIImage(named: "headshot"))
        self.profilePictureView = image
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
        self.profilePictureView.clipsToBounds = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}