//
//  JSPatchTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/5/12.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
import JSPatch

@objc(JPJSClassTest)
class JPJSClassTest:NSObject {
    //
    dynamic class func isPassA() -> Bool{
        //
        return false
    }
    
    dynamic class func isPassB() -> Bool{
        //
        return false
    }
    
    
    dynamic class func isPassC() -> Bool{
        //
        return false
    }
}

class JSPatchTest: XCTestCase {

//    - (void)loadPatch:(NSString *)patchName
//    {
//    NSString *jsPath = [[NSBundle bundleForClass:[self class]] pathForResource:patchName ofType:@"js"];
//    [JPEngine evaluateScriptWithPath:jsPath];
//    }

    func loadPatch(patchName:String) {
        //
        let jsPath = NSBundle.init(forClass: JSPatchTest.self).pathForResource(patchName, ofType: "js")
        JPEngine.evaluateScriptWithPath(jsPath!)
    }
    
    override func setUp() {
        super.setUp()
        JPEngine.startEngine()
        JPEngine.addExtensions(["JPMemory", "JPStructPointer", "JPCoreGraphics", "JPUIKit"])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        loadPatch("jsClassTest")
        
        XCTAssert(JPJSClassTest.isPassA())
        XCTAssert(JPJSClassTest.isPassB())
        XCTAssert(JPJSClassTest.isPassC())
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
