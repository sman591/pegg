//
//  Challenge.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/8/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import Foundation
import UIKit

class Challenge: NSObject {
    
    let name: String
    let distance: String
    let id: String
    let timestamp: String
    let details: String
    let lat: Double
    let lng: Double
    var image: UIImage
    
    required init(name: String, distance: String, id: String, timestamp: String, details: String, lat: Double, lng: Double) {
        self.name = name
        self.distance = distance
        self.id = id
        self.timestamp = timestamp
        self.image = UIImage(named: "headshot")!
        self.details = details
        self.lat = lat
        self.lng = lng
    }
    
}