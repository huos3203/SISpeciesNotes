//
//  test.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/16.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Foundation
import SnapKit
import Alamofire
//import SISpeciesNotes

class test
{
    

    public func saygoodbye(name:String)
    {
        print("你好...\(name)")
        
        Alamofire.request(NSURLRequest(URL: NSURL(string: "https://www.baidu.com")!))
    }

}
