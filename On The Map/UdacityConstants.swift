//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/25/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        static let AppContent = "application/json"
    }
    
    // MARK: Methods
    struct Methods {
        static let getUserData = "/users/<user_id>"
        static let session = "/session"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "<user_id>"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionID = "id"
        
        // MARK: Account
        static let Account = "account"
        static let UserID = "key"
        
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"

    }
    
    // MARK: HTTPHeaderFieldKeys
    struct HTTPHeaderFieldKeys {
        
        static let Access = "Accept"
        static let AppContent = "Content-Type"
        
    }

  
}

