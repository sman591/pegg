//
//  AuthenticationManager.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/6/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//


import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class AuthenticationManager: NSObject {
    
    struct Constants {
        static let NullToken = "NULL_TOKEN"
        static let TokenKey = "token"
    }
    
    class var token: String {
        get {
            if let key = KeychainWrapper.stringForKey(Constants.TokenKey) {
                return key
            } else {
                return Constants.NullToken
            }
        }
        set {
            let saveSuccessful: Bool = KeychainWrapper.setString(newValue, forKey: Constants.TokenKey)
        }
    }
    
    class func invalidateToken() {
        self.token = Constants.NullToken
    }
    
    class func isLoggedIn() -> Bool {
        return self.token != Constants.NullToken
    }
    
}