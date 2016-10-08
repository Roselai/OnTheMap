//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Shukti Shaikh on 8/3/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    
    func getStudentLocations(completionHandlerForGetStudentLocations: (student: [StudentInformation]!, errorString: String?) -> Void){
        
        let parameters = [ParseClient.ParameterKeys.limit : ParseClient.ParameterValues.limit,
                          ParseClient.ParameterKeys.order: ParseClient.ParameterValues.order] as [String : AnyObject]
        
        self.taskForGETMethod(parameters) { (result, error) in
            
            
            if error != nil {
                if let error = error {
                    completionHandlerForGetStudentLocations(student: nil, errorString: error.localizedDescription)
                }
            } else {
                if let resultsArray = result?["results"] as? [[String: AnyObject]]   {
                    
                    let student = Student.sharedInstance().studentsFromResults(resultsArray)
                    completionHandlerForGetStudentLocations(student: student, errorString: nil)
                    
                } else {
                    completionHandlerForGetStudentLocations(student: nil, errorString: "Could not find student information in \(result)")
                    
                }
            }
            
        }

    }
    
    func postMyLocation(mapString: String, url: String, latitude: Double, longitude: Double, completionHandlerForPostMyLocation: (success: Bool, errorString: String?) -> Void) {
        
        if let userId = UdacityClient.sharedInstance().userID {
            UdacityClient.sharedInstance().getNameFromUserID(userId) { (firstName, lastName, errorString) in
                if errorString != nil {
                    if let error = errorString {
                        completionHandlerForPostMyLocation(success: false, errorString: error)
                    }}
                else {
                    if let fName = firstName, let lName = lastName {
                        let jsonBody = "{\"uniqueKey\": \"\(userId)\", \"firstName\": \"\(fName)\", \"lastName\": \"\(lName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
                        
                        self.taskForPOSTMethod(jsonBody, completionHandlerForPOST: { (result, error) in
                            if error != nil {
                                
                                completionHandlerForPostMyLocation(success: false, errorString: "Student location posting failed.")
                                
                            }
                            else {
                                completionHandlerForPostMyLocation(success: true, errorString: nil)
                            }
                        })
                    }
                    
                    
                    
                }
                
            }
        }

        
    }
    
}
