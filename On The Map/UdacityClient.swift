//
//  UdacityClient.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/14/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//



import Foundation


class UdacityClient : NSObject {
    
    // MARK: Properties
    var userID: String? = nil
    var sessionID: String? = nil
    
    // shared session
    var session = NSURLSession.sharedSession()
   
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: (result: AnyObject? , error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: UdacityURLWithPathExtension(UdacityClient.Methods.session))
        request.HTTPMethod = "POST"
        request.addValue(UdacityClient.Constants.AppContent, forHTTPHeaderField: UdacityClient.HTTPHeaderFieldKeys.Access)
        request.addValue(UdacityClient.Constants.AppContent, forHTTPHeaderField: UdacityClient.HTTPHeaderFieldKeys.AppContent)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                
            }
            
            /* GUARD: Was there an error? */
            let errorString = error?.localizedDescription
            guard (error == nil) else {
                sendError("There was an error with your request: \(errorString!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299
                else {
                    let code = (response as? NSHTTPURLResponse)?.statusCode
                    switch (code)! {
                    case 403: sendError("Incorrect Username or Password")
                        break
                    case 400: sendError("Network connection failed")
                        break
                    default: sendError("Returned statusCode of: \(code)")
                    }
                    
                    
                    return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            

        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETMethod(method: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: UdacityURLWithPathExtension(method))
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            let errorString = error?.localizedDescription
            guard (error == nil) else {
                sendError("There was an error with your request: \(errorString!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }


    // MARK: DELETE
    
    func taskForDELETEMethod(completionHandlerForDELETE: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(URL: UdacityURLWithPathExtension(UdacityClient.Methods.session))
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(result: nil, error: NSError(domain: "taskForDELETEMethod", code: 1 , userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            let errorString = error?.localizedDescription
            guard (error == nil) else {
                sendError("There was an error with your request: \(errorString!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }


    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("\(key)") != nil {
            return method.stringByReplacingOccurrencesOfString("\(key)", withString: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }


    // create a URL from parameters
    private func UdacityURLWithPathExtension(pathExtension: String?) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (pathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
       return components.URL!
        
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}


