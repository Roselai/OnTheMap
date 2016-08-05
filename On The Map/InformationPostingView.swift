//
//  InformationPostingView.swift
//  On The Map
//
//  Created by Shukti Shaikh on 8/4/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol InformationPostingViewDelegate{
    func myVCDidFinish(controller:InformationPostingView, coordinate: CLLocationCoordinate2D)
}


class InformationPostingView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userID = UdacityClient.sharedInstance().userID
    var delegate:InformationPostingViewDelegate? = nil
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        
        
    }
    
    @IBAction func submitLocationButtonPressed(sender: AnyObject) {
        
        //TODO: Post student location to server then dismissViewController
        
        let addressString = self.locationTextfield.text
        let url = self.urlTextField.text
        
        
        activityIndicator.startAnimating()
        
        CLGeocoder().geocodeAddressString(addressString!, completionHandler: { (placemarks, error) in
            
            
                
                if let placemark = placemarks![0] as CLPlacemark? {
                    self.activityIndicator.stopAnimating()
                    
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    let latitude = (coordinate?.latitude)!
                    let longitude = (coordinate?.longitude)!
                    
                    
                    ParseClient.sharedInstance().postMyLocation(addressString!, url: url!, latitude: latitude, longitude: longitude, completionHandlerForPostMyLocation: { (success, errorString) in
                        
                        if let errorString = errorString {
                            
                            performUIUpdatesOnMain{
                            self.showAlertWithMessage(errorString)
                            }
                            
                        }else {
                            if (self.delegate != nil) {
                                
                                self.delegate!.myVCDidFinish(self, coordinate: coordinate!)
                            }
                            performUIUpdatesOnMain{
                            self.dismissViewControllerAnimated(true, completion: {print("Location Successfully Posted")})
                            }
                        }})
                    
                    
                }
                else {
                    if let error = error {
                        performUIUpdatesOnMain{
                        self.showAlertWithMessage(error.localizedDescription)
                        }
                        
                        
                    }
                }
        })
    }
    
    
    
    
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true) {
            print("Location Posting Cancelled")
        }
    }
    
    func showAlertWithMessage (errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
