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

@available(iOS 7.0, OSX 10.10, *)
@objc
class JPTestProtocolObject: NSObject,JPTestProtocol,JPTestProtocol2 {
    //
    func testProtocolMethods() -> Bool {
        
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
    
    var testBoxingObjPassed:Bool!
    
    var funcReturnBlockPassed:Bool!
    var funcReturnObjectBlockPassed:Bool!
    var callBlockWithStringAndIntReturnValuePassed:Bool!
    var callBlockWithBoolAndBlockPassed:Bool!
    var callBlockWithObjectAndBlockPassed:Bool!
    
    var funcToSwizzleWithStringViewIntPassed:Bool!
    var funcToSwizzleViewCalledOriginalPassed:Bool!
    
    var funcToSwizzleReturnViewPassed:Bool!
    var funcToSwizzleParamNilPassed:Bool!
    var funcToSwizzleReturnIntPassed:Bool!
    
    var classFuncToSwizzleReturnObjPassed:Bool!
    var classFuncToSwizzleReturnObjCalledOriginalPassed:Bool!
    
    //
    dynamic func funcWithInt(intValue:Int) {
        //
        funcWithIntPassed = intValue == 42
    }
    
    dynamic func funcWithNil(nilObj:AnyObject?){
        funcWithNilPassed = nil
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
    
    func funcWithNull(nullObj:NSNull){
        funcWithNullPassed = nullObj.isKindOfClass(NSNull.self)
    }
    
    func funcTestNSNumber(num:NSNumber) -> NSNumber {
        return num
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
    
    func funcWithNil(nilObj:AnyObject?,dict:[String:String],str:String,num:Double) {
        //
        funcWithNilAndOthersPassed = nilObj == nil && dict["K"] == "JSPatch" && str == "JSPatch" && num - 4.2 < 0.001
    }
}


//MARK:  NSDictionary / NSArray
extension JPTestObject{
    
    func funcWithDict(dict:[String:String],doubleValue:Double) {
        //
        let dictPass = dict["test"] == "test"
        let doublePass = doubleValue - 4.2 < 0.001
        funcWithDictAndDoublePassed = dictPass && doublePass
    }
    
    func funcReturnDict(dict:NSDictionary) -> NSDictionary{
        return dict
    }
    
    func funcReturnDictStringInt() -> [String:AnyObject] {
        //
        return ["str":"stringFromOC","num":NSNumber.init(int: 42)]
    }
    
    func funcReturnDictStringView()->[String:AnyObject]{
        let view = UIView.init(frame: CGRectMake(0, 0, 100, 100))
        return ["view":view,"str":"stringFromOC"]
    }
    
    func funcReturnArrayControllerViewString() -> [AnyObject] {
        //
        let controller = UIViewController()
        let view = UIView()
        return [controller,view,"stringFromOC"]
    }
    
    func getString()->String {
        //
        return "JSPatch"
    }
    
    func getArray() -> [AnyObject] {
        //
        return ["JSPatch",1]
    }
    
    func getDictionary() -> [String:String] {
        //
        return ["k":"JSPatch"]
    }
    func funcTestBoxingObj(data:Array<AnyObject>) {
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
    
    func funcReturnBlock() -> ISTestBlock {
        //
        let block:ISTestBlock = {(str,num) in
            self.funcReturnBlockPassed = str == "stringFromJS" && num == 42
        }
        return block
    }
    
    func funcReturnObjectBlock() -> JPTestObjectBlock {
        //
        let block:JPTestObjectBlock = {(dict,view)->AnyObject in
           self.funcReturnObjectBlockPassed = dict["str"] as! String == "stringFromJS" && (dict["view"] as! NSObject).isKindOfClass(UIView.self) && view.frame.size.width == 100
            return "succ"
        }
        return block
    }
    
    func callBlockWithStringAndInt(block:(String,Int)->AnyObject) {
        //
        let ret = block("stringFromOC",42)
        self.callBlockWithStringAndIntReturnValuePassed = ret as! String == "succ"
    }
    
    func callBlockWithArrayAndView(block:(Array<AnyObject>,UIView)->()) {
        //
        let view = UIView.init(frame: CGRectMake(0, 0, 100, 100))
        block(["stringFromOC",view],view)
    }
    
    func callBlockWithBoolAndBlock(block:(Bool,ISTestBlock)->()) {
        //
        let cbBlock:ISTestBlock = {(str,num) in
            self.callBlockWithBoolAndBlockPassed = str == "stringFromJS" && num == 42
        }
        block(true,cbBlock)
    }
    
    func callBlockWithObjectAndBlock(block:(UIView,JPTestObjectBlock)->()) {
        //
        let view = UIView.init(frame: CGRectMake(0, 0, 100, 100))
        let cbBlock:JPTestObjectBlock = {(dict,view)->AnyObject in
            self.callBlockWithObjectAndBlockPassed = dict["str"] as! String == "stringFromJS" && (dict["view"]as! NSObject).isKindOfClass(UIView.self) && view.frame.size.width == 100
            return "succ"
        }
        block(view,cbBlock)
    }
}

//MARK: - swizzle
struct JPTestStruct{
    var name:Character
    var idx:Int
}

extension JPTestObject{
    
    
    func callSwizleMethod() {
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
        if (ret as! NSObject).isKindOfClass(JPTestObject.self){
            classFuncToSwizzleReturnObjPassed = true
        }
        
    }
    
    func funcToSwizzleWithString(str:String,view:UIView,i:Int) {
        //
        funcToSwizzleWithStringViewIntPassed = false
    }
    
    func funcToSwizzle(num:Double,view:UIView?) {
        //
        self.funcToSwizzleViewCalledOriginalPassed = ((4.2 - num) < 0.01) && (view != nil)
    }
    
    func funcToSwizzleReturnView(view:UIView?)->UIView? {
        //
        return nil
    }
    
    func funcToSwizzleReturnInt(num:Int) -> Int {
        //
        return 0
    }
    
    func funcToSwizzleReturnDictionary(dict:NSDictionary) -> NSDictionary? {
        //
        return nil
    }
    
    func funcToSwizzleReturnJSDictionary() -> NSDictionary? {
        return nil
    }
    
    func funcToSwizzleReturnArray(arr:NSArray) -> NSArray? {
        return nil
    }
    
    func funcToSwizzleReturnString(str:NSString) -> NSString? {
        return nil
    }
    
    func funcToSwizzleWithBlock(block:(UIView,Int)->()) {
        //
        
    }
    
    func funcToSwizzle_withUnderLine_(num:Int) {
        //
    }
    
    func funcToSwizzleReturnRect(rect:CGRect) -> CGRect {
        return CGRectZero
    }
    
    func funcToSwizzleReturnPoint(point:CGPoint) -> CGPoint {
        //
        return CGPointZero
    }
    
    func funcToSwizzleReturnSize(size:CGSize) -> CGSize {
        return CGSizeZero
    }
    func funcToSwizzleReturnRange(range:NSRange) -> NSRange {
        //
        return NSMakeRange(0, 0)
    }
    func funcToSwizzleReturnEdgeInsets(edgeInsets:UIEdgeInsets) -> UIEdgeInsets {
        //
        return UIEdgeInsetsZero
    }
    
    func funcToSwizzleTestGCD(block:()->()) {
        //
    }
    
    func funcToSwizzleTestClass(cls:AnyClass) -> AnyClass? {
        return nil
    }
    
    func funcToSwizzleTestSelector(selector:Selector) -> Selector? {
        return nil
    }
    
    func funcToSwizzleTestChar(cStr:Character) -> Character? {
        //
        return nil
    }
    
    func funcReturnChar() -> Character? {
//        return "JSPatch"
        return nil
    }
    
    class func classFuncToSwizzle(testObject:JPTestObject,i:Int) {
        //
        
    }
    
    class func classFuncToSwizzleReturnObj(obj:JPTestObject) -> AnyObject? {
        //
        obj.classFuncToSwizzleReturnObjCalledOriginalPassed = true
        return nil
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

