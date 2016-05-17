//
//  JPTestObject.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/5/16.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Foundation

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

//@available(iOS 7.0, OSX 10.10, *)
@objc
class JPTestProtocolObject: NSObject,JPTestProtocol,JPTestProtocol2 {
    //
    dynamic func testProtocolMethods() -> Bool {
        
        //        let dNum = protocolWithDouble(4.2, dict: ["name":"JSPatch"])
        //        let iNum = protocolWithInt(42)
        //        let str = JPTestProtocolObject.classProtocolWithString("JSPatch", int: 42)
        //        return dNum - 4.2 < 0.001 && iNum == 42
        return false
    }
    
}


//MARK: 参数和基本类型的方法
@objc(JPTestObject)
class JPTestObject: NSObject {

    dynamic var funcReturnVoidPassed = false
    dynamic var funcReturnStringPassed = false
    dynamic var funcReturnViewWithFramePassed = false
    dynamic var funcWithViewAndReturnViewPassed = false
    
    dynamic var funcWithIntPassed = false
    dynamic var funcWithNilPassed = false
    dynamic var funcReturnNilPassed = false
    dynamic var funcWithNilAndOthersPassed = false
    dynamic var funcWithNullPassed = false
    dynamic var funcTestBoolPassed = false
    dynamic var funcTestNSNumberPassed = false
    
    dynamic var funcWithDictAndDoublePassed = false
    
    dynamic var funcWithRangeAndReturnRangePassed = false
    dynamic var funcWithRectAndReturnRectPassed = false
    dynamic var funcWithPointAndReturnPointPassed = false
    dynamic var funcWithSizeAndReturnSizePassed = false
    
    dynamic var testBoxingObjPassed = false
    
    dynamic var funcReturnBlockPassed = false
    dynamic var funcReturnObjectBlockPassed = false
    dynamic var callBlockWithStringAndIntReturnValuePassed = false
    dynamic var callBlockWithBoolAndBlockPassed = false
    dynamic var callBlockWithObjectAndBlockPassed = false
    
    dynamic var funcToSwizzleWithStringViewIntPassed = false
    dynamic var funcToSwizzleViewCalledOriginalPassed = false
    
    dynamic var funcToSwizzleReturnViewPassed = false
    dynamic var funcToSwizzleParamNilPassed = false
    dynamic var funcToSwizzleReturnIntPassed = false
    
    dynamic var classFuncToSwizzleReturnObjPassed = false
    dynamic var classFuncToSwizzleReturnObjCalledOriginalPassed = false
    
    dynamic var funcTestCharPassed = false
    dynamic var funcTestPointerPassed = false
    
    
    dynamic var funcToSwizzleViewPassed = false
    dynamic var funcToSwizzleWithBlockPassed = false
    dynamic var funcToSwizzle_withUnderLine_Passed = false
    dynamic var funcToSwizzleReturnRectPassed = false
    dynamic var funcToSwizzleReturnPointPassed = false
    dynamic var funcToSwizzleReturnSizePassed = false
    dynamic var funcToSwizzleReturnRangePassed = false
    dynamic var funcToSwizzleReturnEdgeInsetsPassed = false
    dynamic var funcToSwizzleReturnRectJSPassed = false
    dynamic var funcToSwizzleReturnPointJSPassed = false
    dynamic var funcToSwizzleReturnSizeJSPassed = false
    dynamic var funcToSwizzleReturnRangeJSPassed = false
    dynamic var funcToSwizzleReturnEdgeInsetsJSPassed = false
    dynamic var funcToSwizzleTestGCDPassed = false
    dynamic var funcToSwizzleTestClassPassed = false
    dynamic var funcToSwizzleTestSelectorPassed = false
    dynamic var funcToSwizzleTestCharPassed = false
    dynamic var funcToSwizzleTestPointerPassed = false
    dynamic var funcTestSizeofPassed = false
    dynamic var funcTestGetPointerPassed = false
    dynamic var funcTestNSErrorPointerPassed = false
    dynamic var funcTestNilParametersInBlockPassed = false
    dynamic var classFuncToSwizzlePassed = false
    dynamic var classFuncToSwizzleReturnIntPassed = false
    
    
    dynamic var funcCallSuperPassed = false
    dynamic var callForwardInvocationPassed = false
    dynamic var propertySetFramePassed = false
    dynamic var propertySetViewPassed = false
    
    dynamic var newTestObjectReturnViewPassed = false
    dynamic var newTestObjectReturnBoolPassed = false
    dynamic var newTestObjectCustomFuncPassed = false
    
    dynamic var mutableArrayPassed = false
    dynamic var mutableStringPassed = false
    dynamic var mutableDictionaryPassed = false
    
    dynamic var funcWithTransformPassed = false
    dynamic var transformTranslatePassed = false
    dynamic var funcWithRectPointerPassed = false
    dynamic var funcWithTransformPointerPassed = false
    
    dynamic var consoleLogPassed = false
    dynamic var overrideParentMethodPassed = false
    
    dynamic var variableParameterMethodPassed = false
    
    dynamic var funcCallSuperSubObjectPassed = false
    
    //
    dynamic func funcWithInt(intValue:Int) {
        //
        funcWithIntPassed = intValue == 42
    }
    
    dynamic func funcWithNil(nilObj:AnyObject?){
        funcWithNilPassed = false
    }
    
    dynamic func funcReturnNil()-> AnyObject?{
        return nil
    }
    
    dynamic func funcTestBool(b:Bool) -> Bool {
        //
        return b
    }
    
    dynamic func funcReturnVoid() {
        //
        funcReturnVoidPassed = true
    }
    
    dynamic func funcWithNull(nullObj:NSNull){
        funcWithNullPassed = nullObj is NSNull
    }
    
    dynamic func funcTestNSNumber(num:NSNumber) -> NSNumber {
        return num
    }
    
    dynamic func funcReturnString() ->String{
        //
        return "stringFromOC"
    }
    
    //----------Foundation数据类型
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
    
    dynamic func funcWithNil(nilObj:AnyObject?,dict:[String:String],str:String,num:Double) {
        //
        funcWithNilAndOthersPassed = nilObj == nil && dict["K"] == "JSPatch" && str == "JSPatch" && num - 4.2 < 0.001
    }
    
}


//MARK:  NSDictionary / NSArray
extension JPTestObject{
    
    dynamic func funcWithDict(dict:[String:String],doubleValue:Double) {
        //
        let dictPass = dict["test"] == "test"
        let doublePass = doubleValue - 4.2 < 0.001
        funcWithDictAndDoublePassed = dictPass && doublePass
    }
    
    dynamic func funcReturnDict(dict:NSDictionary) -> NSDictionary{
        return dict
    }
    
    dynamic func funcReturnDictStringInt() -> [String:AnyObject] {
        //
        return ["str":"stringFromOC","num":NSNumber.init(int: 42)]
    }
    
    dynamic func funcReturnDictStringView()->[String:AnyObject]{
        let view = UIView.init(frame: CGRectMake(0, 0, 100, 100))
        return ["view":view,"str":"stringFromOC"]
    }
    
    dynamic func funcReturnArrayControllerViewString() -> [AnyObject] {
        //
        let controller = UIViewController()
        let view = UIView()
        return [controller,view,"stringFromOC"]
    }
    
    dynamic func getString()->String {
        //
        return "JSPatch"
    }
    
    dynamic func getArray() -> [AnyObject] {
        //
        return ["JSPatch",1]
    }
    
    dynamic func getDictionary() -> [String:String] {
        //
        return ["k":"JSPatch"]
    }
    dynamic func funcTestBoxingObj(data:Array<AnyObject>) {
        //
        let str = data[0]
        let dict:[String:String] = data[1] as! [String : String]
        let arr = data[2]
        testBoxingObjPassed = str as! String == getString() && dict["k"] == getDictionary()["k"] && arr[0] as! String == getArray()[0] as! String
    }
}

//MARK: - block
typealias ISTestBlock = (String,Int)->()
typealias JPTestObjectBlock = (Dictionary<String,AnyObject>,UIView)->AnyObject
extension JPTestObject{
    
    dynamic func funcReturnBlock() -> ISTestBlock {
        //
        let block:ISTestBlock = {(str,num) in
            self.funcReturnBlockPassed = str == "stringFromJS" && num == 42
        }
        return block
    }
    
    dynamic func funcReturnObjectBlock() -> JPTestObjectBlock {
        //
        let block:JPTestObjectBlock = {(dict,view)->AnyObject in
           self.funcReturnObjectBlockPassed = dict["str"] as! String == "stringFromJS" && (dict["view"] as! NSObject) is UIView && view.frame.size.width == 100
            return "succ"
        }
        return block
    }
    
    dynamic func callBlockWithStringAndInt(block:(String,Int)->AnyObject) {
        //
        let ret = block("stringFromOC",42)
        self.callBlockWithStringAndIntReturnValuePassed = ret as! String == "succ"
    }
    
    dynamic func callBlockWithArrayAndView(block:(Array<AnyObject>,UIView)->()) {
        //
        let view = UIView.init(frame: CGRectMake(0, 0, 100, 100))
        block(["stringFromOC",view],view)
    }
    
    dynamic func callBlockWithBoolAndBlock(block:(Bool,ISTestBlock)->()) {
        //
        let cbBlock:ISTestBlock = {(str,num) in
            self.callBlockWithBoolAndBlockPassed = str == "stringFromJS" && num == 42
        }
        block(true,cbBlock)
    }
    
    dynamic func callBlockWithObjectAndBlock(block:(UIView,JPTestObjectBlock)->()) {
        //
        let view = UIView.init(frame: CGRectMake(0, 0, 100, 100))
        let cbBlock:JPTestObjectBlock = {(dict,view)->AnyObject in
            self.callBlockWithObjectAndBlockPassed = dict["str"] as! String == "stringFromJS" && (dict["view"]as! NSObject)is UIView && view.frame.size.width == 100
            return "succ"
        }
        block(view,cbBlock)
    }
}

//MARK: - swizzle
@objc(JPTestStruct)
struct JPTestStruct{
    var name:CChar
    var idx:Int
}

extension JPTestObject{
    
    dynamic func callSwizzleMethod() {
        //
        funcToSwizzleWithString("stringFromOC", view: UIView(), i: 42)
        funcToSwizzle(4.2, view: UIView())
        let view = funcToSwizzleReturnView(UIView.init(frame: CGRectMake(0, 0, 100, 100)))
        funcToSwizzleReturnViewPassed = view?.frame.size.width == 100
        let nilView = funcToSwizzleReturnView(nil)
        funcToSwizzleParamNilPassed = (nilView != nil)
        
        let num = funcToSwizzleReturnInt(42)
        funcToSwizzleReturnIntPassed = num == 42
        
        JPTestObject.classFuncToSwizzle(self, i: 10)
        let ret = JPTestObject.classFuncToSwizzleReturnObj(self)
        if ((ret as! NSObject) is JPTestObject){
            classFuncToSwizzleReturnObjPassed = true
        }
        
    }
    
    dynamic func funcToSwizzleWithString(str:String,view:UIView,i:Int) {
        //
        funcToSwizzleWithStringViewIntPassed = false
    }
    
    dynamic func funcToSwizzle(num:Double,view:UIView?) {
        //
        self.funcToSwizzleViewCalledOriginalPassed = ((4.2 - num) < 0.01) && (view != nil)
    }
    
    dynamic func funcToSwizzleReturnView(view:UIView?)->UIView? {
        //
        return nil
    }
    
    dynamic func funcToSwizzleWithBlock(block:(UIView,Int)->()) {
        //
        
    }
    
    dynamic func funcToSwizzle_withUnderLine_(num:Int) {
        //
    }
    
    dynamic func funcToSwizzleTestGCD(block:()->()) {
        //
    }
    
    dynamic func funcToSwizzleTestSelector(selector:Selector) -> Selector? {
        return nil
    }
}

//MARK: C语言 Char ,指针
extension JPTestObject{
    
    dynamic func funcToSwizzleTestChar(cStr:CChar) -> CChar? {
        //
        return nil
    }
    
    dynamic func funcReturnChar() -> CChar {
        //String.fromCString("")
        let charString = "JSPatch"
        let ccharOptional = charString.cStringUsingEncoding(NSUTF8StringEncoding)?[0]  // CChar?
        let cchar = (charString.cStringUsingEncoding(NSUTF8StringEncoding)?[0])!   // CChar
        return cchar
    }
    
    dynamic func funcTestChar(cStr:CChar) {
        //self.funcTestCharPassed = strcmp("JSPatch", cStr) == 0;
        let charString = "JSPatch"
        let cchar = (charString.cStringUsingEncoding(NSUTF8StringEncoding)?[0])!   // CChar
        funcTestCharPassed = cchar == cStr
    }
    
    //    https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithCAPIs.html#//apple_ref/doc/uid/TP40014216-CH8-ID17
    dynamic func funcToSwizzleTestPointer(pointer:UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<Void> {
        //
        return nil
    }
    
    dynamic func funcTestNSErrorPointer(error:NSErrorPointer) -> Bool {
        //
        let tmp = NSError.init(domain: "com.albert43", code: 43, userInfo: ["msg":"test error"])
        error.memory = tmp
        return true
    }
    
    dynamic func funcReturnPointer() -> JPTestStruct {
        //
        let charString = "JSPatch"
        let cchar = (charString.cStringUsingEncoding(NSUTF8StringEncoding)?[0])!   // CChar
        let testStruct = JPTestStruct.init(name: cchar, idx: 42)
        return testStruct
    }
    
    dynamic func funcTestPointer(pointer:UnsafeMutablePointer<Void>) {
        //
//        let testStruct:UnsafeMutablePointer<JPTestStruct> = pointer
//        funcTestPointerPassed = testStruct.idx == 42 && testStruct
    }
    
    dynamic func funcTestGetPointer1(str:String) -> Bool {
        if str == "JSPatch" {
            return true
        }
        return false
    }

    dynamic func funcTestGetPointer2(error:NSError) -> Bool {
        //
        let errDescription = error.userInfo.description
        if errDescription == ["msg":"test"].description {
            return true
        }
        return false
    }
    
    dynamic func funcTestGetPointer3(arr:UnsafeMutablePointer<Void>) -> Bool {
        //
//        let p = arr
//        for i in 0..<10 {
//            //
////            if p[i] != "A"{
////                return false
////            }
//        }
        return true
    }
   
}

//MARK: Foundation数据类型
extension JPTestObject{

    dynamic func funcToSwizzleReturnRect(rect:CGRect) -> CGRect {
        return CGRectZero
    }
    
    dynamic func funcToSwizzleReturnPoint(point:CGPoint) -> CGPoint {
        //
        return CGPointZero
    }
    
    dynamic func funcToSwizzleReturnSize(size:CGSize) -> CGSize {
        return CGSizeZero
    }
    dynamic func funcToSwizzleReturnRange(range:NSRange) -> NSRange {
        //
        return NSMakeRange(0, 0)
    }
    dynamic func funcToSwizzleReturnEdgeInsets(edgeInsets:UIEdgeInsets) -> UIEdgeInsets {
        //
        return UIEdgeInsetsZero
    }
}

//MARK: String,Number,集合,字典
extension JPTestObject{

    dynamic func funcToSwizzleReturnInt(num:Int) -> Int {
        //
        return 0
    }
    
    dynamic func funcToSwizzleReturnDictionary(dict:NSDictionary) -> NSDictionary? {
        //
        return nil
    }
    
    dynamic func funcToSwizzleReturnJSDictionary() -> NSDictionary? {
        return nil
    }
    
    dynamic func funcToSwizzleReturnArray(arr:NSArray) -> NSArray? {
        return nil
    }
    
    dynamic func funcToSwizzleReturnString(str:NSString) -> NSString? {
        return nil
    }
}

//MARK: class类转换
extension JPTestObject{
    
    dynamic func funcToSwizzleTestClass(cls:AnyClass) -> AnyClass? {
        return nil
    }

    class dynamic func classFuncToSwizzle(testObject:JPTestObject,i:Int) {
        //
    }
    
    class dynamic func classFuncToSwizzleReturnObj(obj:JPTestObject) -> AnyObject? {
        //
        obj.classFuncToSwizzleReturnObjCalledOriginalPassed = true
        return nil
    }

}

//MARK: block 
extension JPTestObject{

    typealias JSBlock = (NSError!)->NSString
    dynamic func funcGenerateBlock() -> JSBlock {
        //
        let block:JSBlock = {(err) in
            if err != nil {
                return err.description
            }else{
                return "no error"
            }
        }
        return block
    }
    
    dynamic func excuteBlockWithNilParameters(blk:JSBlock!) -> NSString? {
        //
        if blk != nil{
            //
            return blk(nil)
        }
        return nil
    }
}



class JPTestSubObject: JPTestObject {
    //
    
    
    func funcCallSuper() {
        //
        funcCallSuperSubObjectPassed = true
    }
}

