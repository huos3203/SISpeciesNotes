//
//  SISpeciesNotesTests.swift
//  SISpeciesNotesTests
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import XCTest
import RealmSwift

//[NSHipster](http://nshipster.com/xctestcase/)
//[cocoachina](http://www.cocoachina.com/industry/20140805/9314.html)
// 一个基本的测试类，每个使用 Realm 进行的测试都应当继承自该类，而不是直接继承自 XCTestCase 类
class SISpeciesNotesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    //代码质量性能测试
    func testDateFormatterPerformance() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        
        let date = NSDate()
        
        self.measureBlock() {
            let string = dateFormatter.stringFromDate(date)
        } 
    }
    
//    异步测试的支持，借助 XCTestExpectation 类来实现。现在，测试能够为了确定的合适的条件等待一个指定时间长度，而不需要求助于GCD。
    func testAsynchronousURLConnection() {
        let URL = "http://nshipster.com/"

        //首先使用 expectationWithDescription 建立一个期望值。
        let expectation = expectationWithDescription("GET \(URL)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: URL)!, completionHandler: {(data, response, error) in
            //在异步方法被测试的相关的回调中实现那个期望值
            expectation.fulfill()
            
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as! NSHTTPURLResponse! {
                XCTAssertEqual(HTTPResponse.URL!.absoluteString, URL, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(HTTPResponse.MIMEType! as String, "text/html", "HTTP response content type should be text/html")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
        })
        
        task.resume()
//        在方法底部，增加 waitForExpectationsWithTimeout 方法，指定一个超时，如果测试条件不适合时间范围便会结束执行：
        waitForExpectationsWithTimeout(task.originalRequest!.timeoutInterval, handler: { error in
            task.cancel() 
        }) 
    }
}