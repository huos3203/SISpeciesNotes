//: [Previous](@previous)

import Foundation

import UIKit

import SISNotes  //Playgroud中使用个人项目中的类相关方法，需要借助于Custom Frameworks桥接
import OHHTTPStubs
import Alamofire

//import DoubleTimer

//延时执行的黑魔法
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely(true)


//扩展NSTimer方法，提高代码更高的可读性
/// 原文地址：http://radex.io/swift/nstimer/
let timer = NSTimer.every(4.second) {
    print("nihao")
}

NSTimer.after(8) {
    print("第六秒:\(NSDate())")
    timer.invalidate()
}






//: [Next](@next)
