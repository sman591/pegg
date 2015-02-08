//
//  PeggViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit

class PeggViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    var pegg = Pegg(image: nil, description: nil, lat: nil, lng: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.userInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("takeAPegg"))
        imageView.addGestureRecognizer(tapGesture)
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
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendPegg(sender: UIButton) {
        if (pegg.image == nil || pegg.description == nil || pegg.lat == nil || pegg.lng == nil) {
            println("Failed validation")
            return
        }
        PeggAPI.createPegg(pegg.image!, description: pegg.description!, lat: pegg.lat!, lng: pegg.lng!, { json in
            println("Uploaded!!")
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if pegg.image == nil {
            takeAPegg()
        }
    }

}