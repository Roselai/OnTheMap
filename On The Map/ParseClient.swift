//
//  ParseClient.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/27/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation


class ParseClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
    // MARK: GET
    
     func taskForGETMethod(parameters: [String:AnyObject]? = nil, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //optional
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: self.parseURLFromParameters(parameters))
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.ApiKey)
        
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
    
    
    // MARK: POST
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //none
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: parseURLFromParameters())
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.ApiKey)
        request.addValue(ParseClient.Constants.AppContent, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppContent)
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
                sendError("There was an error with your POST request: \(errorString!)")
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: QUERY
    
    func taskForQueryMethod(jsonBody: String, completionHandlerForQuery: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //none
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(URL: parseURLFromParameters())
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.ApiKey)
        request.addValue(ParseClient.Constants.AppContent, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppContent)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForQuery(result: nil, error: NSError(domain: "taskForQueryMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            let errorString = error?.localizedDescription
            guard (error == nil) else {
                sendError("There was an error with your query request: \(errorString!)")
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForQuery)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: PUT
    
    func taskForPUTMethod(jsonBody: String, objectID: String, completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(URL: parseURLFromParameters(withPathExtension: subtituteKeyInMethod(ParseClient.Methods.objectID, key:"objectId", value: objectID)))
        request.HTTPMethod = "PUT"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.ApiKey)
        request.addValue(ParseClient.Constants.AppContent, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppContent)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(result: nil, error: NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    
    // substitute the key for the value that is contained within the method name
     func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("<\(key)>") != nil {
            return method.stringByReplacingOccurrencesOfString("<\(key)>", withString: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult!, error: nil)
    }
    
    // create a URL from parameters
    private func parseURLFromParameters(parameters: [String:AnyObject]? = nil, withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        if (parameters != nil) {
        for (key, value) in parameters! {
            let queryItem = NSURLQueryItem(name: key, value: value as? String )
            components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}

