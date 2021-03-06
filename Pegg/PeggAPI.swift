//
//  PeggAPI.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/7/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AFNetworking

let PeggAPIDidFailMessageKey = "PeggAPIDidFailMessageKey"

class PeggAPI {
    
    typealias PeggAPIFailure = (NSError, String?) -> Void
    typealias PeggAPISuccess = JSON -> Void
    
    class var delegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    private struct Constants {
        static let sharedInstance = PeggAPI()
        static let baseURL = "http://friendlyu.com/pegg/"
    }
    
    class func didFailRequest(message: String) {
        AuthenticationManager.invalidateToken()
        self.delegate.didLogOut(message)
    }
    
    class func signUp(first: String, last: String, email: String, username: String, password: String, completion: PeggAPISuccess, failure:  PeggAPIFailure? = nil) {
        self.makeRequest(.POST, route: "addUser.php", parameters: ["user": username, "pass": password, "first": first, "last": last, "email": email], completion: { json in
            AuthenticationManager.token = json["data"]["token"].stringValue
            completion(json)
            }, failure: failure)
    }
    
    class func authenticate(username: String, password: String, completion: PeggAPISuccess, failure: PeggAPIFailure? = nil) {
        self.makeRequest(.POST, route: "loginUser.php", parameters: ["user": username, "pass": password], completion: { json in
            AuthenticationManager.token = json["token"].stringValue
            completion(json)
            }, failure: failure)
    }
    
    class func search(query: String, completion: PeggAPISuccess, failure: PeggAPIFailure? = nil) {
        self.makeRequest(.POST, route: "search.php", parameters: ["query": query], completion: completion, failure: failure)
    }
    
    class func addFriend(recipient: String, completion: PeggAPISuccess, failure: PeggAPIFailure? = nil) {
        self.makeRequest(.POST, route: "addFriend.php", parameters: ["recipient": recipient], completion: completion, failure: failure)
    }
    
    class func getChallenges(lat: String, lng: String, completion: PeggAPISuccess, failure: PeggAPIFailure? = nil) {
        self.makeRequest(.POST, route: "challenges.php", parameters: ["lat": lat, "lng": lng], completion: completion, failure: failure)
    }
    
    class func getPegg(id: String, completion: PeggAPISuccess, failure: PeggAPIFailure? = nil) {
        self.makeRequest(.POST, route: "getPegg.php", parameters: ["peggid": id], completion: completion, failure: failure)
    }
    
    class func loadProfile(completion: PeggAPISuccess) {
        self.makeRequest(.POST, route: "me.php", completion: completion)
    }
    
    class func createPegg(image: UIImage, description: String, lat: Double, lng: Double, community: String, receivers: String, completion: PeggAPISuccess) {
        
        let manager = AFHTTPRequestOperationManager()
        
        let url = "http://friendlyu.com/pegg/peggs/sendPegg.php"
        
        var fileURL = UIImageJPEGRepresentation(image, 0.7)
        
        var params = [
            "description":description,
            "lat" : lat,
            "lng" : lng,
            "community" : community,
            "receivers" : receivers,
            "token" : AuthenticationManager.token,
            "typeOfContent":"photo"
        ]
        
        manager.POST( url, parameters: params,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                data.appendPartWithFileData(fileURL, name: "file", fileName: "file.jpg", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
        })
        
    }
    
    class func makeRequest(method: Alamofire.Method, route: String, parameters: [String: AnyObject]? = nil, completion: PeggAPISuccess? = nil, failure: PeggAPIFailure? = nil) {
        var fullParameters = parameters ?? [String: AnyObject]()
        fullParameters["token"] = AuthenticationManager.token
        Alamofire.request(method, Constants.baseURL + route, parameters: fullParameters)
            .validate()
            .responseJSON { request, response, data, error in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    if let error = error {
                        failure?(error, json["message"].string)
                        if let response = response {
                            if response.statusCode == 401 {
                                self.delegate.didLogOut(json["message"].stringValue)
                            }
                        }
                    } else {
                        completion?(json["data"])
                    }
                }
        }
        
    }
}