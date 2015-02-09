//
//  PeggViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import CoreLocation

class PeggViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate,
    UITextViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendPeggButton: UIButton!
    
    let picker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var placeholderLabel : UILabel!
    
    var pegg = Pegg(image: nil, description: nil, lat: nil, lng: nil, receivers: nil, community: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendPeggButton.layer.cornerRadius = 5
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            let alertVC = UIAlertController(title: "Error", message: "Location services are not enabled. Please enable them in your settings.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
            alertVC.addAction(okAction)
            presentViewController(alertVC, animated: true, completion: nil)
        }
        
        imageView.userInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("takeAPegg"))
        imageView.addGestureRecognizer(tapGesture)
        
        textView.delegate = self
        
        // Source: http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter description..."
        placeholderLabel.font = UIFont.italicSystemFontOfSize(textView.font.pointSize)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, textView.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.5)
        placeholderLabel.hidden = countElements(textView.text) != 0
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
    }
    
    func takeAPegg() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = .Camera
            picker.cameraCaptureMode = .Photo
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, you need a camera.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        pegg.image = img
        imageView.image = pegg.image
        
        let coord = locationManager.location.coordinate
        pegg.lat = coord.latitude
        pegg.lng = coord.longitude
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        pegg = Pegg(image: nil, description: nil, lat: nil, lng: nil, receivers: nil, community: nil)
        imageView.image = nil
        takeAPegg()
    }
    
    @IBAction func sendPegg(sender: UIButton) {
        
        pegg.description = textView.text ?? ""
        if (pegg.lat == nil || pegg.lng == nil) {
            pegg.lat = -1
            pegg.lng = -1
        }
        pegg.receivers = "test"
        pegg.community = "true"
        
        PeggAPI.createPegg(pegg.image!, description: pegg.description!, lat: pegg.lat!, lng: pegg.lng!, community: pegg.community!, receivers: pegg.receivers!, { json in
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if pegg.image == nil {
            takeAPegg()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = countElements(textView.text) != 0
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange: NSRange, replacementText: String!) -> Bool {
        if (replacementText == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}