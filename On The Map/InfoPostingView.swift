//
//  InfoPostingView.swift
//  On The Map
//
//  Created by Shukti Shaikh on 8/8/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class infoPostingView: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationFinderStack: UIStackView!
    @IBOutlet weak var LinkPostingStack: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        linkTextView.delegate = self
        locationTextView.delegate = self
        
        LinkPostingStack.hidden = true
        
        self.setButtonAttributes(submitButton)
        self.setButtonAttributes(findOnTheMapButton)
        locationTextView.layer.borderColor = UIColor.blackColor().CGColor
        locationTextView.layer.borderWidth = 1
        
    }
    
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = ""
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func locationEntered(sender: UIButton) {
        
        let locationString = self.locationTextView.text
        
        activityIndicator.startAnimating()
        
        CLGeocoder().geocodeAddressString(locationString, completionHandler: {(placemarks, error) in
            
            if let placemark = placemarks![0] as CLPlacemark? {
                self.activityIndicator.stopAnimating()
                self.locationFinderStack.hidden = true
                self.LinkPostingStack.hidden = false
                
                
                let location = placemark.location
                let coordinate = location?.coordinate
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegion(center: coordinate!, span: span)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate!
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                
                
            } else {
                if let error = error {
                    let errorString = error.localizedDescription
                    let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        })
        
        
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        ParseClient.sharedInstance().postMyLocation(self.locationTextView.text, url: self.linkTextView.text, latitude: self.latitude!, longitude: self.longitude!, completionHandlerForPostMyLocation: { (success, errorString) in
            
            if let errorString = errorString {
                let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }else {
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true, completion: {
                        print("Location Successfully Posted")
                        
                    })
                }
            }})
        
        
    }
    
    
    
    
    func setButtonAttributes(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
        
    }
    
    
}
