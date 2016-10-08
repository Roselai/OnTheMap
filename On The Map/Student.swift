//
//  Student.swift
//  On The Map
//
//  Created by Shukti Shaikh on 10/7/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import UIKit

class Student: NSObject {
    
    var students = [StudentInformation]()
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
     func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for student in results {
            students.append(StudentInformation(dictionary: student))
        }
        
        return students
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Student {
        struct Singleton {
            static var sharedInstance = Student()
        }
        return Singleton.sharedInstance
    }

    
}