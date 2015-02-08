//
//  Friend.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/8/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import Foundation

class Friend: NSObject {
    let username: String
    var first: String
    var last: String
    
    required init(username: String) {
        self.username = username
        self.first = ""
        self.last = ""
    }
    
    required init(username: String, first: String, last: String) {
        self.username = username
        self.first = first
        self.last = last
    }
    
    func fullName() -> String {
        return self.first + " " + self.last
    }
}