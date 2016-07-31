//: [Previous](@previous)

import Cocoa
import XCPlayground


let countDownField = NSTextField.init(frame: CGRectMake(0, 0, 40, 80))
countDownField.stringValue = "eeeeee"
var superView = NSView.init(frame: CGRectMake(0, 0, 500, 200))
superView.addSubview(countDownField)
countDownField.fireTimer(10)

XCPlaygroundPage.currentPage.liveView = superView




//: [Next](@next)
