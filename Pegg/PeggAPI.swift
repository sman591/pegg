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
    
    class func loadProfile(completion: PeggAPISuccess) {
        self.makeRequest(.POST, route: "me.php", completion: completion)
    }
    
    class func createPegg(image: UIImage, description: String, lat: Double, lng: Double, completion: PeggAPISuccess) {
        let fileURL = NSBundle.mainBundle().URLForResource("Default", withExtension: "png")
        var parameters = [
            "token": AuthenticationManager.token,
            "description": description,
            "lat": String(format:"%.1f", lat),
            "lng": String(format:"%.1f", lng),
            "receivers": "People",
            "community": "true"
        ]
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let urlRequest = self.urlRequestWithComponents(Constants.baseURL + "peggs/sendPegg.php", parameters: parameters, imageData: imageData)
        
        Alamofire.upload(urlRequest.0, urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { (request, response, JSON, error) in
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
        }
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
    
    // Source: http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire/26747857#26747857
    class func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
}