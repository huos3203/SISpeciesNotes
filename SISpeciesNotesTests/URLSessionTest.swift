//
//  URLSessionTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/18.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
/*
    NSURLConnection
    NSURLSession ,  NSURLSessionConfiguration  , NSURLSessionTask
 - NSURLSession—A session object.
 - NSURLSessionConfiguration—A configuration object used when initializing the session.
 - NSURLSessionTask—The base class for tasks within a session.
    - NSURLSessionDataTask—A task for retrieving the contents of a URL as an NSData object
        - NSURLSessionUploadTask—A task for uploading a file, then retrieving the contents of a URL as an NSData object
    - NSURLSessionDownloadTask—A task for retrieving the contents of a URL as a temporary file on disk
*/
class URLSessionTest: XCTestCase {
    
    var baidu:NSURL!
    var request:NSURLRequest!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //访问网络两个必不可缺少的
        baidu = NSURL(string:"https://www.baidu.com")
        request = NSURLRequest.init(URL: baidu!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    //传统方法NSURLConnection
    func testConnection(){
        
        print("请求路径地址：\(request.URLString)")
        let expecttaion = expectationWithDescription("timeout....")
        //一个URL ,一个request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            expecttaion.fulfill()
            print("响应的服务器地址：\(response?.URL?.absoluteString)")
            XCTAssertNotNil(data,"数据返回为nil")
            XCTAssertNil(error, (error?.localizedDescription)!)
            //处理响应信息
            //response.
            //解析Data
            guard let dataFormatString = String(data: data!, encoding:NSUTF8StringEncoding)
            else
            {
                print("百度网页源码:\(data!)")
                return
            }
            print("百度网页源码:\(dataFormatString)")
            
            
        }
        waitForExpectationsWithTimeout(10){ error in
            //
            print("错误信息:\(error?.localizedDescription)")
        }
    }
    
    //使用NSURLSession访问服务
    func testSession()
    {
        let expectation = expectationWithDescription("session timeout ...")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            //
            
            
            
            expectation.fulfill()
        }
    }
    
}
