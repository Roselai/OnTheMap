//
//  MapViewController.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/13/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, InformationPostingViewDelegate {
    
    // MARK: PROPERTIES
    var udacityClient = UdacityClient.sharedInstance()
    var students: [StudentInformation] = [StudentInformation]()
    var annotationsArray: [MKAnnotation]?

    // MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        
        // create and set the logout button
        let button = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(logout))
        
        parentViewController!.navigationItem.leftBarButtonItem = button

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        getStudentLocations()
    }
    
    
    
    
    func addPin() {
        for index in 0...(self.students.count - 1) {
            let latitude = self.students[index].latitude
            let longitude = self.students[index].longitude
            let title = self.students[index].firstName + " " + self.students[index].lastName
            let info = self.students[index].mediaURL
            let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude) )
            let annotation = Annotation.init(title: title, coordinate: coordinate, info: info)
            self.annotationsArray?.append(annotation)
            self.mapView.addAnnotation(annotation)
            }

    }


    // MARK: Logout

    func logout() {
        
            udacityClient.logOutOfUdacity { (success, errorString) in
                
            if let errorString = errorString {
                print(errorString)
            } else {
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true, completion: {print("Successfully logged out")})
                }
        }
        }
    }
    
    func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations { (student, errorString) in
            
            
            if let error = errorString {
                let alert = UIAlertController(title: nil, message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                performUIUpdatesOnMain{
                self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                
                self.students = student!
                performUIUpdatesOnMain{
                self.addPin()
                }
                }
                
            
        
        
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        let identifier = "Location"
        
        if annotation is Annotation {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let button = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = button
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }


    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
       let annotation = view.annotation as! Annotation
            
            if let url = NSURL(string: annotation.info) {
                UIApplication.sharedApplication().openURL(url)
            }
        
            
        
    }
    
    func myVCDidFinish(controller: InformationPostingView, coordinate: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegionMakeWithDistance(
            coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
        
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    


}

