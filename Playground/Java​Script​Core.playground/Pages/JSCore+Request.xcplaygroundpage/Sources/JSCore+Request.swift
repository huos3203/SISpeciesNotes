//
//  JSCore+Request.swift
//  JSCore
//
//  Created by Lex Tang on 4/27/15.
//  Copyright (c) 2015 Lex Tang. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc(RequestExport)
public protocol RequestExport : JSExport {
    var URL: NSURL? { get }
    
    func get() -> NSString
    func post(params: [String]?) -> NSString
}

@objc(Request)
public class Request : NSMutableURLRequest, RequestExport {
    
    public func get() -> NSString {
        var error : NSError?
        var response : NSURLResponse?
        self.HTTPMethod = "GET"
        self.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        let data: NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(self, returningResponse: &response)
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        if let err = error {
            print("\(err)")
            return ""
        }
        if let _ = response {
            if let __ = data {
                return NSString(data: __, encoding: NSUTF8StringEncoding) ?? ""
            }
        }
        return ""
    }
    
    public func post(params: [String]?) -> NSString {
        var error : NSError?
        var response : NSURLResponse?
        self.HTTPMethod = "POST"
        self.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        if let p = params {
            if let d = p.joinWithSeparator("&").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                self.HTTPBody = d
            }
        }
        let data: NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(self, returningResponse: &response)
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        if let err = error {
            print("\(err)")
            return ""
        }
        if let _ = response {
            if let __ = data {
                return NSString(data: __, encoding: NSUTF8StringEncoding) ?? ""
            }
        }
        return ""
    }
}

extension JSCore
{
    public func requireRequestModule()
    {
        let request : @objc_block (String!) -> Request = {
            (url: String!) -> Request in
            return Request(URL: NSURL(string: url)!)
        }
        
        let requestObj : AnyObject = unsafeBitCast(request, AnyObject.self)
        self.setObject(requestObj, forKeyedSubscript: "Request")
    }
}
