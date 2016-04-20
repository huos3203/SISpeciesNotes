//
//  File.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/21.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Foundation
import SnapKit
import Alamofire
//import SISpeciesNotes

public class test1
{
    var name = "dddd"
    
    public init()
    {
        self.name = ""
    }
    public func saygoodbye1(name:String)
    {
        print("你好...\(name)")
        
        Alamofire.request(NSURLRequest(URL: NSURL(string: "https://www.baidu.com")!))
    }
    
}
