//: Playground - noun: a place where people can play

import UIKit
import JSPatch
import XCPlayground



//defineClass -> ddddrrviewController ,Swift类在Objective-C中会有模块前缀，
//即：在JS中绑定类方法defineClass中时，必须先使用@objc指定的该类的名称，否则无法找到该类。

//在Playground中似乎不需要。使用 defineClass() 覆盖 Swift 类时，类名应为 项目名.原类名，例如项目 demo 里用 Swift 定义了 ViewController 类，在 JS 覆盖这个类方法时要这样写

//JSPatch只支持调用继承自NSObject的Swift类，其继承自父类的方法具有动态性，其他自定义方法、属性需要加dynamic修饰才可以获得动态性。
//本案例中，genView方法必须添加dynamic修饰符
@objc(ddddrrviewController)
class rrviewController :UIViewController{
    
    override func viewDidLoad() {
        //
        JPEngine.startEngine()
        let script = try! String.init(contentsOfURL: [#FileReference(fileReferenceLiteral: "Demo.js")#], encoding: NSUTF8StringEncoding)
        JPEngine.evaluateScript(script)
        let vieww = genView()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(vieww)
    }
    
    //overrided in JS 必须添加dynamic修饰符
    dynamic func genView() -> UIView {
        //
        return UIView.init(frame: CGRectMake(0, 0, 320, 320))
    }
}
XCPlaygroundPage.currentPage.liveView = rrviewController()
