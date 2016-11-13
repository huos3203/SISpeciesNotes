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

/*
 这个框架是基于NSURLProtocol实现的，可以在it或者beforeAll或者beforeEach的时候进行stub request，即上面这段代码的行为。但是不要忘记的是，需要在tear down的时候，即specta的afterAll的时候，记得调用 [OHHTTPStubs removeAllStubs] 。
 
 由于NSURLProtocol的局限性，OHHTTPStubs没法用来测试background sessions和模拟数据上传
 
 注意，这里只是使用NSURLProtocol来stub request，不会影响被测试的请求接口的测试，请求是异步的话，可以使用Specta的it/waitUntil/done()流程对请求进行测试，如果使用XCTest的话，OHTTPStubs给出了一个wiki解决，使用XCTestExpectation来搞定，我觉得挺有意思
*/
class OHHTTPStubsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        Alamofire.request(.GET,"")
        
        
        OHHTTPStubs.onStubActivation { (request: URLRequest, stub: OHHTTPStubsDescriptor, response: OHHTTPStubsResponse) in
            print("[OHHTTPStubs] Request to \(request.url) has been stubbed with \(stub.name)")
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
        let req = URLRequest(url: URL(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue.main) { (_, data, _) in
            //
            if let receiveData = data
            {
                print("图片数据长度:\(receiveData.count)")
            }
        }
    }
    
    
//    设置模拟图片延迟加载
    weak var imageStub:OHHTTPStubsDescriptor?
    
    func installImageStub(_ requestdelay:TimeInterval,responseTime:TimeInterval)
    {
        imageStub = stub(condition: (isExtension("png")||isExtension("jpg")), response: { _ in
            //
            let imagePath = OHPathForFile("stub.jpg", type(of: self))
            let header:[NSString:AnyObject]? = ["Content-Type":"image/jpeg" as AnyObject]
            return fixture(filePath: imagePath!, headers: header).requestTime(requestdelay, responseTime: responseTime)
        })
        imageStub?.name = "Image stub"
    }
    
    
//    测试下载data时，延时加载的
    func testDownloadText()
    {
        //模拟延迟加载：请求延迟1s , 响应延时:2s
        installTextStub(1, responseDelay: 2)
        //
        let expetion = expectation(description: "超时....")
        //在使用OHHTTPStubs拦截时，后缀名文件放在“/”后即可，不需要真实存在的路径
        let urlString = "http://www.opensource/com.txt"
        let req = URLRequest(url: URL(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue.main){ (_, data, _) in
            
            expetion.fulfill()
            print("data长度：\(data?.count)")
            //
            if let receiveData = data, let receiveText = NSString(data:receiveData,encoding:String.Encoding.ascii.rawValue)
            {
                
                print("文本内容：\(receiveText)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
//    
    weak var textStub:OHHTTPStubsDescriptor?
    func installTextStub(_ requestDelay:TimeInterval,responseDelay:TimeInterval)
    {
        //
        textStub = stub(condition: isExtension("txt"), response: { _  in
            
            let txtStr = "stub.txt"
            //In Swift 2, use self.dynamicType instead of the type(of: self) Swift 3 syntax
            let txtPath = OHPathForFile(txtStr, type(of: self))
            print("文件路径:\(txtPath)")
           let header:[NSString:AnyObject]? = ["Content-Type":"image/jpeg" as AnyObject]
            return fixture(filePath: txtPath!, headers: header)
                .requestTime(requestDelay, responseTime: responseDelay)
//            return fixture(filePath: , headers: ["Content-Type":"text/plain"] as [NSObject:AnyObject]?).requestTime(requestDelay, responseTime: responseDelay)
        })
        
    }
    
}
