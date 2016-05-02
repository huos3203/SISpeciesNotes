//
//  AsyncTheOldWayTest.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/16.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
@testable import Alamofire
@testable import SISpeciesNotes

class AsyncTheOldWayTest: XCTestCase {

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
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    /**
     http://www.cocoachina.com/ios/20141027/10052.html
     //在Xcode 6之前的版本里面并没有内置XCTest，想使用Xcode测试的只能是在主线程的RunLoop里面使用一个while循环,然后一直等待响应或者直到timeout.
     
     这个while循环在主线程里面每隔10毫秒会跑一次，直到有响应或者5秒之后超出响应时间限制才会跳出.
     */
    func testAsyncTheOldWay()
    {
        let timeoutDate = NSDate.init(timeIntervalSinceNow: 5.0)
        var responseHasArrived = false
        Alamofire.request(.GET,"https://www.baidu.com").responseData{response in
            print("获取到的数据长度：\(String(data: response.data!, encoding:NSUTF8StringEncoding)!)")
            responseHasArrived = true
            XCTAssert(response.data?.length > 0)
        }
    
        while (responseHasArrived == false && (timeoutDate.timeIntervalSinceNow > 0)) {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, false)
        }
    
        
        if (responseHasArrived == false)
        {
            XCTFail("Test timed out")
        }
    }

    /**
     *  @author shuguang, 16-04-16 22:04:08
     *
     *  高期望(High Expectations)
     在Xcode 6里，苹果以XCTestExpection类的方式向XCTest框架里添加了测试期望(test expection)。
     1. 设置测试期望XCTestExpection：测试框架就会预计它在之后的某一时刻被实现
     2. 设置测试期望时效：waitForExpectationsWithTimeout:handler:
     3. 实现测试期望 fulfill: 在程序完成代码块中的测试代码会调用fulfill方法实现期望。这一方法替代了responseHasArrived作为Flag的方式。
     如果完成处理的代码在指定时限里执行并调用了fulfill方法，那么就说明所有的测试期望在此期间都已经被实现。否则就测试就被打断不再执行
     
     当然，失败结果并不意味着失败的测试，只有不明就里的测试结果才算失败的测试。
     *
     *  @since 1.0
     */
    func testWebPageDownload(){
        //设置期望
        let expection = expectationWithDescription("失败时显示原因")
        
        Alamofire.request(.GET,"https://www.baidu.com").responseData{response in
            print("获取到的数据长度：\(String(data: response.data!, encoding:NSUTF8StringEncoding)!)")
            XCTAssert(response.data?.length > 0)
            expection.fulfill()
        }
        
        //在方法底部指定一个超时，如果测试条件不适合时间范围便会结束执行：
        waitForExpectationsWithTimeout(5) { error in
            //
            print("错误信息:\(error?.localizedDescription)")
        }
    }
    
    
    /**
     //原文：http://liuyanwei.jumppo.com/2016/03/10/iOS-unit-test.html?utm_source=tuicool&utm_medium=referral
     
        expectationForNotification 方法 ,该方法监听一个通知,如果在规定时间内正确收到通知则测试通过。
     */
    func testAsynForNotification()
    {
        //监听测试通知
        expectationForNotification("BLDownloadImageNotification", object: nil) { (notification) -> Bool in
            //
            let userInfo = notification.userInfo as! [String:String]
            let name = userInfo["name"]
            let sex = userInfo["sex"]
            print("name:\(name), sex = \(sex)")
            return true
        }
        //发送通知
//        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["name":"huosan","sex":"man"])
        
        //设置延迟多少秒后，如果没有满足测试条件就报错
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    

    /**
     这个例子也可以用expectationWithDescription实现,帮助理解 expectationForNotification 方法和 expectationWithDescription 的区别。
     同理，expectationForPredicate方法也可以使用expectationWithDescription实现。
     */
    func testAsynForNotificationWithExpectation() {
        let expectation = expectationWithDescription("BLDownloadImageNotification")
        let sub = NSNotificationCenter.defaultCenter().addObserverForName("BLDownloadImageNotification", object: nil, queue: nil) { (not) -> Void in
            expectation.fulfill()
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: nil)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        NSNotificationCenter.defaultCenter().removeObserver(sub)
    }
    
    /**
       通过userInfo参数 传递 expectation 
     */
    func testAsynForNotificationWithExpectation2() {
        let expectation = expectationWithDescription("BLDownloadImageNotification")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AsyncTheOldWayTest.downLoadImage(_:)), name: "BLDownloadImageNotification", object: nil)

        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["name":"huosan","sex":"man","expectation":expectation])
        
        waitForExpectationsWithTimeout(1, handler: nil)
                NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func downLoadImage(notification:NSNotification) {
        //
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        let name = userInfo["name"]
        let sex = userInfo["sex"]
        print("name:\(name), sex = \(sex)")
        
        let expectation = userInfo["expectation"] as! XCTestExpectation
        expectation.fulfill()
        
    }
    
    
    /**
     *  @author shuguang, 16-04-16 23:04:47
     *
     *  expectationForPredicate：
     *  利用谓词计算，button是否正确的获得了backgroundImage，如果正确20秒内正确获得则通过测试，否则失败。
     *  @since 1
     */
    func testThatBackgroundImageChanges(){
        
        let viewController = OnclickLikeViewController()
//        viewController.loadView()  //不执行viewDidload方法
        let _ = viewController.view
        let button = viewController.button
        let img = button.backgroundImageForState(.Normal)
        XCTAssertNil(img,"此时img不为nil,中止执行")  //当img不是nil时，执行断言
        let predicate = NSPredicate.init { (anyobject, bindings) -> Bool in
            //
            let button = anyobject as! UIButton
            return button.backgroundImageForState(.Normal) != nil
        }
        expectationForPredicate(predicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(20, handler: nil)
    }
    
}
