//
//  ErrorHandingTest.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/17.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest

class ErrorHandingTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //字符串请求网络路径
    func testStringLoadByURL()
    {
        //URL
        let url = NSURL(string: "http://www.baidu.com")
        let str:String // = try? String(contentsOfURL: url! ,encoding: NSUTF8StringEncoding)
        do{
            try str = String(contentsOfURL: url! ,encoding: NSUTF8StringEncoding)
        }catch{
            str = ""
        }
        
        XCTAssert(!str.isEmpty, "正确")
        
    }

}
