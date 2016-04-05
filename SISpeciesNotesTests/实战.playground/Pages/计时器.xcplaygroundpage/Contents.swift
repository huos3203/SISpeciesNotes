//: [Previous](@previous)

import Foundation

import UIKit
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely(true)
var str = "Hello, playground"

//视屏上浮动动画，用户水印每隔20s执行一次显示4秒
class shadeAnimation
{
    let mvFrame = UIScreen().bounds.size
    
    let x_min = 40.0, y_min = 40.0
    let x_max = 40.0 , y_max = 40.0
    
    func makeOrigin(sWidth:Int,sHeight:Int) ->CGPoint
    {
//        定时器
        var timer = NSTimer()
        timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(shadeAnimation.timerFireMethod), userInfo: nil, repeats: true)
        
        NSRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        return CGPointMake(CGFloat(300),CGFloat(400))
    }
    
    @objc func timerFireMethod()
    {
        //随机计算坐标
        var x_random = arc4random() % UInt32(200)
        var y_random = arc4random() % UInt32(400)
        print(".....")
    }
}
let shade = shadeAnimation()
var timer  = NSTimer(timeInterval: 1.0, target: shade, selector: #selector(shadeAnimation.timerFireMethod), userInfo: nil, repeats: true)

//NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)




//: [Next](@next)
