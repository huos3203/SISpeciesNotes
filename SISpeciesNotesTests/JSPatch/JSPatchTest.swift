//
//  JSPatchTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/5/12.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
import JSPatch

//@testable import SISpeciesNotes

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

    func loadPatch(_ patchName:String) {
        //
        let jsPath = Bundle.init(for: JSPatchTest.self).path(forResource: patchName, ofType: "js")
        JPEngine.evaluateScript(withPath: jsPath!)
    }
    
    override func setUp() {
        super.setUp()
        JPEngine.start()
        JPEngine.addExtensions(["JPMemory", "JPStructPointer", "JPCoreGraphics", "JPUIKit"])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //@available(iOS 8.0, OSX 10.10, *)
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testEngine(){
        
        loadPatch("test")
        let objValue = JPEngine.context().evaluateScript("ocObj")
        let obj = objValue?.toObjectOf(JPTestObject.self) as! JPTestObject
        
        XCTAssert(obj.funcReturnVoidPassed,"funcReturnVoidPassed")
        XCTAssert(obj.funcReturnStringPassed, "funcReturnStringPassed")
        XCTAssert(obj.funcWithIntPassed, "funcWithIntPassed")
//
//        
//        XCTAssert(obj.funcWithRectAndReturnRectPassed, "funcWithRectAndReturnRectPassed")
//        XCTAssert(obj.funcWithSizeAndReturnSizePassed, "funcWithSizeAndReturnSizePassed")
//        XCTAssert(obj.funcWithPointAndReturnPointPassed, "funcWithPointAndReturnPointPassed")
//        XCTAssert(obj.funcWithRangeAndReturnRangePassed, "funcWithRangeAndReturnRangePassed")
        
        
    }

}
