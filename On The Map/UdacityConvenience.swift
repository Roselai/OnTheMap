//
//  UdacityClient.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/14/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//


import Foundation

// MARK: - TMDBClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: LOGIN
    
    func logInToUdacity(username:String, password: String, completionHandlerForLogIn: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Set the parameters */
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        self.taskForPOSTMethod(jsonBody) { (result, error) in
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogIn(success: false, errorString: error.localizedDescription)
            } else {
                if let session = result![UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject],
                    currentAccount = result![UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {
                    
                    self.sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
                    self.userID = currentAccount[UdacityClient.JSONResponseKeys.UserID] as? String
                    completionHandlerForLogIn(success: true, errorString: nil)
                    
                } else {
                    print("Could not find sessionID or UserID) in \(result)")
                    self.sessionID = nil
                    self.userID = nil
                    completionHandlerForLogIn(success: false, errorString: "Login Failed (Session ID).")
                }
            }
            
        }
    }
    
    
    // MARK: GET USER DATA
    
    func getPublicUserData(userID: String, completionHandlerForGetPublicUserData: (result: AnyObject!, errorString: String?) -> Void) {
        
        let method = UdacityClient.Methods.getUserData
        let newMethod = self.subtituteKeyInMethod(method, key: UdacityClient.URLKeys.UserID, value: userID)
        
        self.taskForGETMethod(newMethod!) { (result, error) in
            if let error = error {
                completionHandlerForGetPublicUserData(result: nil, errorString: error.localizedDescription)
            } else {
                if let downloadedResult = result {
                completionHandlerForGetPublicUserData(result: downloadedResult, errorString: nil)
                }
            }
        }
    }
    
    
    
    // MARK: GET USER NAME FROM ID
    
    func getNameFromUserID(userID: String, completionHandlerForGetName: (firstName: String?, lastName: String?, errorString: String?) -> Void) {
        
        let method = UdacityClient.Methods.getUserData
        let newMethod = self.subtituteKeyInMethod(method, key: UdacityClient.URLKeys.UserID, value: userID)
        
        self.taskForGETMethod(newMethod!) { (result, error) in
            if let error = error {
                completionHandlerForGetName(firstName: nil, lastName: nil, errorString: error.localizedDescription)
            } else {
                if let user = result[UdacityClient.JSONResponseKeys.User] as? [String: AnyObject] {
                    if let fName = user[UdacityClient.JSONResponseKeys.FirstName] as? String, lName = user[UdacityClient.JSONResponseKeys.LastName] as? String{
                        
                        completionHandlerForGetName(firstName: fName, lastName: lName, errorString: nil)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: LOGOUT
    
    func  logOutOfUdacity(completionHandlerForLogOut: (success: Bool, errorString: String?) -> Void) {
        
        if sessionID != nil {
            
            self.taskForDELETEMethod { (result, error) in
                
                if let error = error {
                    completionHandlerForLogOut(success: false, errorString: error.localizedDescription)
                } else {
                    self.sessionID = nil
                    completionHandlerForLogOut(success: true, errorString: nil)
                    
                }
            }
        }
    }
}
