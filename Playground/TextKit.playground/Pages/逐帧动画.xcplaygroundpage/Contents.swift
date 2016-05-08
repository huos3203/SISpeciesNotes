//: [Previous](@previous)

import Foundation

//在核心动画没有直接提供逐帧动画类型，但是却提供了用于完成逐帧动画的相关对象CADisplayLink。CADisplayLink是一个计时器，但是同NSTimer不同的是，CADisplayLink的刷新周期同屏幕完全一致。例如在iOS中屏幕刷新周期是60次/秒，CADisplayLink刷新周期同屏幕刷新一致也是60次/秒，这样一来使用它完成的逐帧动画（又称为“时钟动画”）完全感觉不到动画的停滞情况。

//iOS程序在运行后就进入一个消息循环中（这个消息循环称为“主运行循环”），整个程序相当于进入一个死循环中，始终等待用户输入。将CADisplayLink加入到主运行循环队列后，它的时钟周期就和主运行循环保持一致，而主运行循环周期就是屏幕刷新周期。在CADisplayLink加入到主运行循环队列后就会循环调用目标方法，在这个方法中更新视图内容就可以完成逐帧动画。

import UIKit
import XCPlayground
//逐帧动画
class CADisplayLinkViewController: UIViewController {
    //
    let linkLayer = CALayer()
    var imageArray = [String]()
    let imageCount = 10
    override func viewDidLoad() {
        ////设置背景
        view.layer.contents = UIImage(named:"bg")?.CGImage
        
        //逐帧动画图层
        linkLayer.bounds = CGRectMake(0, 0, 87, 32)
        linkLayer.position = CGPointMake(160, 284)
        linkLayer.contents = UIImage(named:"fish0")!.CGImage
        view.layer.addSublayer(linkLayer)
        for i in 0..<imageCount {
            //使用加法赋值运算符（+=）也可以直接在数组后面添加一个或多个拥有相同类型的数据项
            imageArray += ["fish\(i)"]
        }
        
        //添加动画
        //定义时钟对象
        let disPlayLink = CADisplayLink.init(target: self, selector: "setup")
        //添加时钟对象到主运行循环
        disPlayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    //每次屏幕刷新就会执行一次此方法(每秒接近60次)
    var currentImageIndex = 0
    var i = 0  ////定义一个变量记录执行次数
    func setup() {
        
        
        //每秒执行6次
        if (++i%10 == 0) {
            ////更新图片
            print("\(imageArray[currentImageIndex])")
            let image = UIImage(named:"\(imageArray[currentImageIndex])")
            linkLayer.contents = image!.CGImage
            currentImageIndex = (currentImageIndex+1)%imageCount
        }
        
    }
}
XCPlaygroundPage.currentPage.liveView = CADisplayLinkViewController()

//: [Next](@next)
