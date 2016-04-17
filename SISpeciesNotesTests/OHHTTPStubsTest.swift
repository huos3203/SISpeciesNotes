//
//  OHHTTPStubsTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/14.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest

//https://github.com/AliSoftware/OHHTTPStubs/wiki/Usage-Examples

@testable import SISpeciesNotes
@testable import Alamofire
@testable import OHHTTPStubs

class OHHTTPStubsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        Alamofire.request(.GET,"")
        
        
        OHHTTPStubs.onStubActivation { (request: NSURLRequest, stub: OHHTTPStubsDescriptor, response: OHHTTPStubsResponse) in
            print("[OHHTTPStubs] Request to \(request.URL!) has been stubbed with \(stub.name)")
        }
        //默认是开启的
        OHHTTPStubs.setEnabled(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    
    func testDownloadImage()
    {
        installImageStub(2, responseTime: 4)
        let urlString = "http://images.apple.com/support/assets/images/products/iphone/hero_iphone4-5_wide.png"
        let req = NSURLRequest(URL: NSURL(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) { (_, data, _) in
            //
            if let receiveData = data
            {
                print("图片数据长度:\(receiveData.length)")
            }
        }
    }
    
    
//    设置模拟图片延迟加载
    weak var imageStub:OHHTTPStubsDescriptor?
    
    func installImageStub(requestdelay:NSTimeInterval,responseTime:NSTimeInterval)
    {
        imageStub = stub((isExtension("png")||isExtension("jpg")), response: { _ in
            //
            let imagePath = OHPathForFile("stub.jpg", self.dynamicType)
            return fixture(imagePath!, headers: ["Content-Type":"image/jpeg"]).requestTime(requestdelay, responseTime: responseTime)
        })
        imageStub?.name = "Image stub"
    }
    
    
//    测试下载data时，延时加载的
    func testDownloadText()
    {
        //模拟延迟加载：请求延迟1s , 响应延时:2s
        installTextStub(1, responseDelay: 2)
        //
        let expetion = expectationWithDescription("超时....")
        //在使用OHHTTPStubs拦截时，后缀名文件放在“/”后即可，不需要真实存在的路径
        let urlString = "http://www.opensource/com.txt"
        let req = NSURLRequest(URL: NSURL(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()){ (_, data, _) in
            
            expetion.fulfill()
            print("data长度：\(data?.length)")
            //
            if let receiveData = data, receiveText = NSString(data:receiveData,encoding:NSASCIIStringEncoding)
            {
                
                print("文本内容：\(receiveText)")
            }
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
//    
    weak var textStub:OHHTTPStubsDescriptor?
    func installTextStub(requestDelay:NSTimeInterval,responseDelay:NSTimeInterval)
    {
        //
        textStub = stub(isExtension("txt"), response: { _  in
            
            let txtStr = "stub.txt"
            let txtPath = OHPathForFile(txtStr, self.dynamicType)
            print("文件路径:\(txtPath)")
            return fixture(txtPath!, headers: ["Content-Type":"text/plain"]).requestTime(requestDelay, responseTime: responseDelay)
        })
        
    }
    
}
