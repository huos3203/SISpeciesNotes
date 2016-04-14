//
//  OHHTTPStubsTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/14.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest

@testable import SISpeciesNotes
@testable import Alamofire
@testable import ObjectMapper
@testable import OHHTTPStubs

class OHHTTPStubsTest: XCTestCase {
    
//    [Testing Alamofire with OHHTTPStub](http://stackoverflow.com/questions/34763783/testing-alamofire-with-ohhttpstub)
      weak var httpStub : OHHTTPStubsDescriptor?
    
    
//    let realm:Realm
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Alamofire.request(.GET,"")
        
        
    }
    
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        if let httpStub = self.httpStub{
            OHHTTPStubs.removeStub(httpStub)
        }
        super.tearDown()
    }
    
    
    func testFetchOverviewItems() {
        
        
        
    }
    
    func installTextStub()
    {
        let  textHandler:OHHTTPStubsDescriptor? // Note: no need to retain this value, it is retained by the OHHTTPStubs itself already :)
    
        if (true)
        {
        // Install nit(fileAtPath filePath: String, statusCode: Int32, headers httpHeaders: [NSObject : AnyObject]?)
            textHandler = OHHTTPStubs.stubRequestsPassingTest({ (request:NSURLRequest) -> Bool in
                    return true
                }, withStubResponse: { (request:NSURLRequest) -> OHHTTPStubsResponse in
                    return OHHTTPStubsResponse(fileAtPath:"",statusCode: 23,headers: nil)
            })
            weak var textStub: OHHTTPStubsDescriptor?
            textStub = stub(isExtension("txt")) { _ in
                let stubPath = OHPathForFile("stub.txt", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/plain"])
                    .requestTime(self.delaySwitch.on ? 2.0 : 0.0, responseTime:OHHTTPStubsDownloadSpeedWifi)
            }
            textStub?.name = "Text stub"
        } else {
            // Uninstall
            OHHTTPStubs.removeStub(textStub!)
        }
            
//        textHandler = [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        // This handler will only configure stub requests for "*.txt" files
//        return [request.URL.absoluteString.pathExtension isEqualToString:@"txt"];
//        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
//        // Stub txt files with this
//        return [OHHTTPStubsResponse responseWithFile:@"stub.txt"
//        contentType:@"text/plain"
//        responseTime:self.delaySwitch.on ? 2.f: 0.f];
//        }];
//        }
//        else
//        {
//        // Uninstall
//        [OHHTTPStubs removeRequestHandler:textHandler];
//        }
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
    
}
