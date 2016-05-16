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


@objc(JPTestObject)
class JPTestObject: NSObject {
    //
    dynamic func funcWithInt(intValue:Int) {
        //
        funcWithIntPassed = intValue == 42
    }
    
    var funcReturnVoidPassed:Bool!
    var funcReturnStringPassed:Bool!
    var funcReturnViewWithFramePassed:Bool!
    var funcWithViewAndReturnViewPassed:Bool!
    
    var funcWithIntPassed:Bool!
    var funcWithNilPassed:Bool!
    var funcReturnNilPassed:Bool!
    var funcWithNilAndOthersPassed:Bool!
    var funcWithNullPassed:Bool!
    var funcTestBoolPassed:Bool!
    var funcTestNSNumberPassed:Bool!
    
    var funcWithDictAndDoublePassed:Bool!
    
    var funcWithRangeAndReturnRangePassed:Bool!
    var funcWithRectAndReturnRectPassed:Bool!
    var funcWithPointAndReturnPointPassed:Bool!
    var funcWithSizeAndReturnSizePassed:Bool!

    
}

extension JPTestObject{

    dynamic func funcReturnVoid() {
        //
        funcReturnVoidPassed = true
    }
    
    dynamic func funcReturnString() ->String{
        //
        return "stringFromOC"
    }
    
    dynamic func funcWithRectAndReturnRect(rect:CGRect)->CGRect {
        //
        return rect
    }
    
    dynamic func funcWithPointAndReturnPoint(point:CGPoint) -> CGPoint {
        //
        return point
    }
    
    dynamic func funcWithSizeAndReturnSize(size:CGSize) -> CGSize {
        //
        return size
    }
    
    dynamic func funcWithRangeAndReturnRange(range:NSRange) -> NSRange {
        //
        return range
    }
    
    dynamic func funcReturnViewWithFrame(frame:CGRect) -> UIView {
        //
        let view = UIView.init(frame: frame)
        return view
    }
}

class JPTestSubObject: JPTestObject {
    //
    var funcCallSuperSubObjectPassed:Bool! = true
    
    func funcCallSuper() {
        //
        funcCallSuperSubObjectPassed = true
    }
    
    
}
@objc
protocol JPTestProtocol:NSObjectProtocol {
    //
    optional func protocolWithDouble(num:Double,dict:NSDictionary) -> Double
    optional static func classProtocolWithString(string:String,int:Int)->String
}


@objc
protocol JPTestProtocol2:NSObjectProtocol {
    //
   optional func protocolWithInt(num:Int) -> Int
}

@available(iOS 7.0, OSX 10.10, *)
@objc
class JPTestProtocolObject: NSObject,JPTestProtocol,JPTestProtocol2 {
    //
    func testProtocolMethods() -> Bool {
        
        let dNum = protocolWithDouble(4.2, dict: ["name":"JSPatch"])
        let iNum = protocolWithInt(42)
        let str = JPTestProtocolObject.classProtocolWithString("JSPatch", int: 42)
        return dNum - 4.2 < 0.001 && iNum == 42
    
    }
    
}


class JSPatchTest: XCTestCase {

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
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testEngine(){
        
        loadPatch("test")
//        let objValue = JPEngine.context().evaluateScript("ocObj")
//        let obj = objValue.toObjectOfClass(JPTestObject.self) as! JPTestObject
        
//        XCTAssert(obj.funcReturnVoidPassed,"funcReturnVoidPassed")
//        XCTAssert(obj.funcReturnStringPassed, "funcReturnStringPassed")
        
//        XCTAssert(obj.funcWithIntPassed, "funcWithIntPassed")
//        
//        
//        XCTAssert(obj.funcWithRectAndReturnRectPassed, "funcWithRectAndReturnRectPassed")
//        XCTAssert(obj.funcWithSizeAndReturnSizePassed, "funcWithSizeAndReturnSizePassed")
//        XCTAssert(obj.funcWithPointAndReturnPointPassed, "funcWithPointAndReturnPointPassed")
//        XCTAssert(obj.funcWithRangeAndReturnRangePassed, "funcWithRangeAndReturnRangePassed")
        
        
    }

}
