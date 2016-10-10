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
    var studentStore = Student.sharedInstance()
    
    // MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        
        // create and set the logout button
        let button = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(logout))
        
        parentViewController!.navigationItem.leftBarButtonItem = button
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refresh))
        parentViewController?.navigationItem.rightBarButtonItem = refreshButton
        
        getStudentLocations()
        
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
    
     // MARK: Refresh
    
    func refresh() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        self.studentStore.students.removeAll()
        getStudentLocations()
        print("updated with student locations")
        
    }
    
    
    func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations { (student, errorString) in
            
            
            if let error = errorString {
                performUIUpdatesOnMain{
                let alert = UIAlertController(title: nil, message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain{
                    self.studentStore.students = student
                    for student in self.studentStore.students {
                        
                        
                        let title = student.firstName! + " " + student.lastName!
                        let subtitle = student.mediaURL
                        
                        
                        let coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude! )
                        let annotation = Annotation.init(title: title, coordinate: coordinate, subtitle: subtitle!)
                        
                        self.mapView.addAnnotation(annotation)}
                }
            }
        }}
    
    
    
    
    
    
    
    
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
        var url: NSURL
        
        if let urlString = annotation.subtitle {
            if urlString.hasPrefix("http") {
                url = NSURL(string: urlString)!
            } else {
                url = NSURL(string: "https://" + urlString)!
            }
            UIApplication.sharedApplication().openURL(url)
        }
        
        
        
        
        
    }
    
    
    
}
