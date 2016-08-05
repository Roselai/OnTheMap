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
    let userID = UdacityClient.sharedInstance().userID
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
    // MARK: GET
    
    func taskForGETMethod(parameters: [String:AnyObject]? = nil, completionHandlerForGET: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //optional
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: self.parseURLFromParameters(parameters))
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.ApiKey)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
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
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
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
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
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
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForQuery(result: nil, error: NSError(domain: "taskForQueryMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
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
    
    func taskForPUTMethod(objectId:String, jsonBody: [String:AnyObject], completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(URL: parseURLFromParameters(withPathExtension: subtituteKeyInMethod(ParseClient.Methods.objectID, key:"<objectId>", value: objectId)))
        request.HTTPMethod = "PUT"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.ApiKey)
        request.addValue(ParseClient.Constants.AppContent, forHTTPHeaderField: ParseClient.HTTPHeaderFieldKeys.AppContent)
        request.HTTPBody = getHTTPBody(jsonBody).dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(result: nil, error: NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
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
    
    private func getHTTPBody(dictionary: [String: AnyObject]) -> String {
        
        var arrayOfStrings = [String]()
        for (key,value) in dictionary {
            
            let str = "\"\(key)\": \"\(value)\""
            arrayOfStrings.append(str)
        }
        
        let stringRepresentation = arrayOfStrings.joinWithSeparator(", ")
        let HTTPBodyString = "{\(stringRepresentation)}"
        return HTTPBodyString
    }

    
    // substitute the key for the value that is contained within the method name
    private func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
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
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
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
            let queryItem = NSURLQueryItem(name: key, value: value as? String)
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

/*
class ParseClient: NSObject {
    
    let clientMethods = ClientMethods()
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
    
    func postStudentLocation (student: [String: AnyObject] )  {
        
        let url = self.getURL()
        let request = createRequest(url,
                                    httpMethod: HTTPMethod.Post,
                                    addValue: [ParseClient.Constants.AppContent : ParseClient.HTTPHeaderFieldKeys.AppContent],
                                    httpBody: student)
        
        clientMethods.methodForTask(request) { (result, error) in
            //TODO: Do something with result
        }
        
    }
    
    func getStudentLocation (completionHandlerForGetStudentLocation: (result: AnyObject!, error: NSError?) -> Void) {
        let url = self.getURL(
            [ParseClient.ParameterKeys.limit : ParseClient.ParameterValues.limit,
            ParseClient.ParameterKeys.order: ParseClient.ParameterValues.order],
            withPathExtention: nil)
        let request = createRequest(url, httpMethod: HTTPMethod.Get)
        
        clientMethods.methodForTask(request) { (result, error) in
            //TODO: Do something with result
            if error == nil {
                self.convertDataWithCompletionHandler(result as! NSData, completionHandlerForConvertData: { (result, error) in
                    if error == nil {

                        completionHandlerForGetStudentLocation(result: result, error: nil)
                    }
                    else {
                        completionHandlerForGetStudentLocation(result: nil, error: error)
                    }
                })
            } else {
                completionHandlerForGetStudentLocation(result: nil, error: error)
            }
        }
    }
    

    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Private Functions
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        let parsedResult: AnyObject!
        do {
            
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandlerForConvertData(result: parsedResult!, error: nil)
    }
    
    private func getURL(withParameters:[String: AnyObject]? = nil, withPathExtention: String? = nil) -> NSURL{
        let url = clientMethods.URLFromParameters(ParseClient.Constants.ApiScheme, host: ParseClient.Constants.ApiHost, path: ParseClient.Constants.ApiPath, parameters: withParameters, withPathExtension: withPathExtention)
        return url
    }
    
    private func getHTTPBody(dictionary: [String: AnyObject]) -> String {
        
        var arrayOfStrings = [String]()
        for (key,value) in dictionary {
            
            let str = "\"\(key)\": \"\(value)\""
            arrayOfStrings.append(str)
        }
        
        let stringRepresentation = arrayOfStrings.joinWithSeparator(",")
        let HTTPBodyString = "{\(stringRepresentation)}"
        return HTTPBodyString
    }
    
    private func createRequest (URL: NSURL, httpMethod: HTTPMethod, addValue:[String:String]? = nil, httpBody: [String: AnyObject]? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = httpMethod.rawValue
        
        var requestValuesDictionary = [ParseClient.Constants.AppID: ParseClient.HTTPHeaderFieldKeys.AppID,
                                       ParseClient.Constants.ApiKey: ParseClient.HTTPHeaderFieldKeys.ApiKey]
        
        if addValue != nil {
            for (key, value) in addValue! {
                requestValuesDictionary[key] = value
            }
        }
        
        for (key,value) in requestValuesDictionary {
            request.addValue(key, forHTTPHeaderField: value)
        }
        
        if httpBody != nil {
            request.HTTPBody = getHTTPBody(httpBody!).dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        
        return request
    }
    

}
 */


