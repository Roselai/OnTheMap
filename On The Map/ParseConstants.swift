//
//  ParseConstants.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/27/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        

        // MARK: API Key
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Parse App ID Key
        static let AppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"

        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        
        static let AppContent = "application/json"
    }
    
    
    // MARK: URL Keys
    struct Methods {
        static let objectID = "/<objectId>"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let limit = "limit"
        static let order = "order"
        static let Query = "query"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let limit = 100
        static let order = "-updatedAt"
        static let Query = "where"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let objectId = "objectId"
        static let queryResults = "results"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let uniqueKey = "uniqueKey"
        
        
    }
    
    // MARK: HTTPHeaderFieldKeys
    struct HTTPHeaderFieldKeys {
        
        static let AppID = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
        static let AppContent = "Content-Type"
        
    }

}
