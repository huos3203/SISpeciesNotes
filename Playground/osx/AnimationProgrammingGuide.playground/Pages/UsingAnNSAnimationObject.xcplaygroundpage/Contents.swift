//: [Previous](@previous)

import Foundation
import AppKit
//import XCPlayground  //过时
import PlaygroundSupport
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
//替换最新之后，只能显示控件，仍然无法显示ViewController
PlaygroundPage.current.liveView = NSViewController()//NSTextField.init(string: "ddgsjfhgskdhfgkjhsfsdf")////.playgroundLiveViewRepresentation()



//: [Next](@next)
