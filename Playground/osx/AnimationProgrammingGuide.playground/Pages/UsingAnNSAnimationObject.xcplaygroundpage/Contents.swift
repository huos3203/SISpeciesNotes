//: [Previous](@previous)

import Foundation
import AppKit
import XCPlayground
//CustomAnimation().viewDidLoad()
//由NSAnimation对象创建动画
//let textView = NSView.init(frame: CGRect.init(x: 10, y: 10, width: 190, height: 109))
//let textLabel = NSTextField.init(string:"dddddddddddddd")
//textView.addSubview(textLabel)

class viewController:NSViewController
{
    override func viewDidLoad()
    {
        //
        let textField = NSTextField.init(string: "ddgsjfhgskdhfgkjhsfsdf")
        view.addSubview(textField)
    }
    
}

XCPlaygroundPage.currentPage.liveView = viewController()



//: [Next](@next)
