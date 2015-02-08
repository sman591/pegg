//
//  Badge.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/8/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import Foundation

class Badge: NSObject {
    var name: String
    var details: String
    
    required init(name: String, details: String) {
        self.name = name
        self.details = details
    }
    
}