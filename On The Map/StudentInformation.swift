//
//  StudentInformation.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/27/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation

struct StudentInformation {
    var objectId: String
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    init( dictionary: [String : AnyObject] ) {
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Double
    }
    
    
//    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
//        var students = [StudentInformation]()
//        
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            students.append(StudentInformation(dictionary: result))
//        }
//        
//        return students
//    }
    
}