//
//  MapViewController.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/13/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    // MARK: PROPERTIES
    var udacityClient = UdacityClient.sharedInstance()
    var students: [StudentInformation] = [StudentInformation]()
    var annotationsArray: [MKAnnotation]?

    // MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
       getStudentLocations()
        self.mapView.delegate = self

        
        // create and set the logout button
        let button = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(logout))
        
        parentViewController!.navigationItem.leftBarButtonItem = button
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refresh))
        parentViewController?.navigationItem.rightBarButtonItem = refreshButton
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
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
    
    func refresh() {
        getStudentLocations()
        print("updated with student locations")
        
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
                performUIUpdatesOnMain{
                self.students = student
                for index in 0...(self.students.count - 1) {
                    let latitude = self.students[index].latitude
                    let longitude = self.students[index].longitude
                    if self.students[index].firstName != nil  && self.students[index].lastName != nil{
                    let title = self.students[index].firstName! + " " + self.students[index].lastName!
                    let info = self.students[index].mediaURL
                    let coordinate = CLLocationCoordinate2D(latitude: Double(latitude!), longitude: Double(longitude!) )
                    let annotation = Annotation.init(title: title, coordinate: coordinate, info: info!)
                    self.annotationsArray?.append(annotation)

                
                
                self.mapView.addAnnotation(annotation)
                }
                }}
                
            
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


}

