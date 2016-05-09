//
//  JSCore.swift
//  JSCore
//
//  Created by Lex Tang on 4/27/15.
//  Copyright (c) 2015 Lex Tang. All rights reserved.
//

import UIKit
import JavaScriptCore

final public class JSCore : JSContext
{
    public class func newContext() -> JSCore
    {
        let context = JSCore(virtualMachine: JSVirtualMachine())
        
        let sum : @objc_block (Int, Int) -> Int = {
            (x: Int, y:Int) -> Int in
            return x + y
        }
        
        let sumObj : AnyObject = unsafeBitCast(sum, AnyObject.self)
        context.setObject(sumObj, forKeyedSubscript: "sum")
        
        return context
    }
    
    public func run(js : String) -> AnyObject {
        let result = self.evaluateScript(js) as JSValue!
        if result.isObject {
            return result.toObject()
        } else if result.isBoolean {
            return Bool(result.isBoolean)
        } else if result.isString {
            return result.toString()
        } else if result.isNumber {
            return result.toNumber()
        }
        return ""
    }
}