//
//  ChallengeViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/8/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import MapKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var challenge: Challenge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = challenge.image
        usernameLabel.text = challenge.name
        dateLabel.text = challenge.timestamp
        descriptionLabel.text = challenge.details
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
