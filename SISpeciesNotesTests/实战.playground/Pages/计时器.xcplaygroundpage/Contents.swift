//: [Previous](@previous)

import Foundation

import UIKit

import SISNotes  //Playgroud中使用个人项目中的类相关方法，需要借助于Custom Frameworks桥接

//延时执行的黑魔法
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely(true)

extension Double
{
    //秒
    var second:Double{ return self}
    //分
    var minute:NSTimeInterval{return self * 60}
    //小时
    var hour:NSTimeInterval{return self * 60 * 60}
    //天
    var day:NSTimeInterval{return self * 60 * 60 * 24}
}

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
