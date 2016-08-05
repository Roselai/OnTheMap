//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Shukti Shaikh on 8/3/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    
    func getStudentLocations(completionHandlerForGetStudentLocations: (student: [StudentInformation]?, errorString: String?) -> Void){
        
        let parameters = [ParseClient.ParameterKeys.limit : ParseClient.ParameterValues.limit,
        ParseClient.ParameterKeys.order: ParseClient.ParameterValues.order]
        
        self.taskForGETMethod(parameters as? [String : AnyObject]) { (result, error) in
            if let error = error {
                completionHandlerForGetStudentLocations(student: nil, errorString: error.localizedDescription)
            } else {
                if let resultsArray = result!["results"] as? [[String: AnyObject]]   {
                    
                    let student = StudentInformation.studentsFromResults(resultsArray)
                    completionHandlerForGetStudentLocations(student:  student, errorString: nil)
                    
                } else {
                    completionHandlerForGetStudentLocations(student:  nil, errorString: "Could not find student information) in \(result)")
                    
                }
            }

        }
    }
    
    func postMyLocation(mapString: String, url: String, latitude: Double, longitude: Double, completionHandlerForPostMyLocation: (success: Bool, errorString: String?) -> Void) {
        UdacityClient.sharedInstance().getNameFromUserID(UdacityClient.sharedInstance().userID) { (firstName, lastName, errorString) in
            if let error = errorString {
                print(error)
            }
            else {
                let jsonBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().userID)\", \"firstName\": \"\(firstName!)\", \"lastName\": \"\(lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
                
                self.taskForPOSTMethod(jsonBody, completionHandlerForPOST: { (result, error) in
                    if let error = error {
                        completionHandlerForPostMyLocation(success: false, errorString: error.localizedDescription)
                    
                    }
                    else {
                        completionHandlerForPostMyLocation(success: true, errorString: nil)
                    }
                })
            }
            
        }
    }
    
}
