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
        
        // 使用当前测试名标识的内存 Realm 数据库。
        // 这确保了每个测试都不会从别的测试或者应用本身中访问或者修改数据，并且由于它们是内存数据库，因此无需对其进行清理。
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        
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
    
//     字符串请求网络路径 http://www.cocoachina.com/ios/20141027/10052.html
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
    
    //http://liuyanwei.jumppo.com/2016/03/10/iOS-unit-test.html?utm_source=tuicool&utm_medium=referral
    /**
     这个测试肯定是通过的，因为设置延迟为3秒，而异步操作2秒就除了一个正确的结果，并宣布了条件满足 [exp fulfill]，但是当我们把延迟改成1秒，这个测试用例就不会成功，错误原因是 expectationWithDescription:"这里可以是操作出错的原因描述。。。"
     */
    func testAsynExample()
    {
        let exp = expectationWithDescription("这里可以是操作出错的原因描述。。。")
        let queue = NSOperationQueue()
        queue.addOperationWithBlock {
            //模拟这个异步操作需要2秒后才能获取结果，比如一个异步网络请求
            sleep(2);
            //模拟获取的异步操作后，获取结果，判断异步方法的结果是否正确
            XCTAssertEqual("a", "a")
            //如果断言没问题，就调用fulfill宣布测试满足
            exp.fulfill()
        }
    
        //设置延迟多少秒后，如果没有满足测试条件就报错
        waitForExpectationsWithTimeout(3){ error in
            if ((error == nil))
            {
                print("Timeout Error: \(error)")
            }
        
        }
        
    }
        /**
         异步测试除了使用 expectationWithDescription以外，还可以使用 expectationForPredicate和expectationForNotification
         
         下面这个例子使用expectationForPredicate 测试方法，代码来自于AFNetworking，用于测试backgroundImageForState方法
         */
        func testThatBackgroundImageChanges()
        {
//            XCTAssertNil(self.button.backgroundImageForState())
//            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIButton  * _Nonnull button, NSDictionary<NSString *,id> * _Nullable bindings) {
//                return [button backgroundImageForState:UIControlStateNormal] != nil;
//                }];
//            
//            [self expectationForPredicate:predicate
//                evaluatedWithObject:self.button
//                handler:nil];
//            [self waitForExpectationsWithTimeout:20 handler:nil];
        }
        
        /**
         expectationForNotification 方法 ,该方法监听一个通知,如果在规定时间内正确收到通知则测试通过。
         */
        func testAsynExample2()
        {
            expectationForNotification("监听通知的名称xxx", object: nil, handler: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("监听通知的名称xxx", object: nil)
            
            //设置延迟多少秒后，如果没有满足测试条件就报错
            waitForExpectationsWithTimeout(3, handler: nil)
        }
        
        
        /**
         这个例子也可以用expectationWithDescription实现,只是多些很多代码而已，但是这个可以帮助你更好的理解 expectationForNotification 方法和 expectationWithDescription 的区别。同理，expectationForPredicate方法也可以使用expectationWithDescription实现。
         */
        func testAsynExample1() {
            let expectation = expectationWithDescription("监听通知的名称xxx")
            let sub = NSNotificationCenter.defaultCenter().addObserverForName("监听通知的名称xxx", object: nil, queue: nil) { (not) -> Void in
                expectation.fulfill()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("监听通知的名称xxx", object: nil)
            waitForExpectationsWithTimeout(1, handler: nil)
            NSNotificationCenter.defaultCenter().removeObserver(sub)
        }
    
//    // Application Code
//    func updateUserFromServer() {
//        let url = NSURL(string: "http://myapi.example.com/user")
//        NSURLSession.sharedSession().dataTaskWithURL(url!) { data, _, _ in
//            let realm = try! Realm()
//            self.createOrUpdateUserInRealm(realm, withData: data!)
//        }
//    }
//    
//    public func createOrUpdateUserInRealm(realm: Realm, withData data: NSData) {
//        let object = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
//            as! [String: String]
//        try! realm.write {
//            realm.create(User.self, value: object, update: true)
//        }
//    }
//    
//    // Test Code
//    
//    let testRealmPath = "..."
//    
//    func testThatUserIsUpdatedFromServer() {
//        let config = Realm.Configuration(path: testRealmPath)
//        let testRealm = try! Realm(configuration: config)
//        let jsonData = "{\"email\": \"help@realm.io\"}"
//            .dataUsingEncoding(NSUTF8StringEncoding)!
//        createOrUpdateUserInRealm(testRealm, withData: jsonData)
//        let expectedUser = User()
//        expectedUser.email = "help@realm.io"
//        XCTAssertEqual(testRealm.objects(User).first!,
//                       expectedUser,
//                       "User was not properly updated from server.")
//    }
    

}