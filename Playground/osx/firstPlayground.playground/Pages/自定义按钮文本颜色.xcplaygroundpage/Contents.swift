//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground
import SnapKit

var str = "Hello, playground"
print(str)

var but = NSButton()
but.title = "ueueuueue"
var attributedString = NSAttributedString.init(string: but.title, attributes: [NSForegroundColorAttributeName:NSColor.redColor()])
but.attributedTitle = attributedString
but.sizeToFit()

var boxView = NSView.init(frame: NSMakeRect(0, 0, 300, 300))
boxView.wantsLayer = true
boxView.layer?.backgroundColor = NSColor.whiteColor().CGColor
boxView.addSubview(but)
but.snp_makeConstraints { (make) in
    make.centerX.equalTo(boxView)
    make.top.equalTo(5)
}

//自定义一个label
let titleLabel = NSTextField.init(frame: NSMakeRect(0, 0, 20, 40))
titleLabel.stringValue = "PBB Readerddd"
titleLabel.backgroundColor = NSColor.blackColor()
titleLabel.textColor = NSColor.whiteColor()

boxView.addSubview(titleLabel)
titleLabel.snp_makeConstraints { (make) in
    //居顶部5 ，水平居中topBanerView
    make.centerX.equalTo(boxView)
    make.left.right.equalTo(0)
    make.top.equalTo(but.snp_bottom).offset(10)
    
}
//titleLabel.sizeToFit()
XCPlaygroundPage.currentPage.liveView = boxView
