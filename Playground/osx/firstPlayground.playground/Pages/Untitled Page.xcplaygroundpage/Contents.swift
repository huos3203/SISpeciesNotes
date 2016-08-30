//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground
var str = "Hello, playground"
print(str)

var but = NSButton()
but.stringValue = "ueueuueue"
var attributedString = NSAttributedString.init(string: but.title, attributes: [NSForegroundColorAttributeName:NSColor.redColor()])
    but.attributedTitle = attributedString
XCPlaygroundPage.currentPage.liveView = but
