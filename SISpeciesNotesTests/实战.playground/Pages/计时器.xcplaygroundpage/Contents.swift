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
    
//    计时器
    let timer:NSTimer = NSTimer(timeInterval: 1.0, target: self, selector: "timerFireMethod", userInfo: nil, repeats: true)
    init()
    {
       timer  =
    }
    
    func makeOrigin(sWidth:Int,sHeight:Int) ->CGPoint
    {
//        定时器
        var timer = NSTimer()
        timer = NSTimer(timeInterval: 1.0, target: self, selector: "timerFireMethod", userInfo: nil, repeats: true)
        
        NSRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        return CGPointMake(CGFloat(300),CGFloat(400))
    }
    
    @objc func timerFireMethod()
    {
        //随机计算坐标
        var x_random = arc4random() % UInt32(200)
        var y_random = arc4random() % UInt32(400)
    }
}
let shade = shadeAnimation()
//shade.makeOrigin(300, sHeight: 400)
var timer  = NSTimer(timeInterval: 1.0, target: shade, selector: "timerFireMethod", userInfo: nil, repeats: true)

//NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)


extension NSTimer
{
    func shadeAnimation(shadeLabel:UILabel)
    {
        let mvFrame = UIScreen().bounds.size
//        随机坐标
        var x_random = arc4random() % UInt32(mvFrame.width)
        var y_random = arc4random() % UInt32(mvFrame.height)
        
//        动画
        UIView.animateWithDuration(1.0, animations: {
            shadeLabel.hidden = true
            shadeLabel.frame.origin = CGPointMake(CGFloat(x_random), CGFloat(y_random))
            
            }) { (completion) -> Void in
                //隐藏之后，暂停20秒再显示出来
                NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "shadeAnimation:", userInfo: nil, repeats: false)
        }
    }
}



//: [Next](@next)
