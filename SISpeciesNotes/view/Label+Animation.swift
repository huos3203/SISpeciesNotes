//
//  Label+Animation.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/6.
//  Copyright © 2016年 益行人. All rights reserved.
//

import Foundation

//: label显示24s之后开始循环随机变动坐标，每间隔20s显示一次，显示时长4s，一次循环。
extension UILabel
{
    
//    class var labelText = "nihao"
    
    var shadeOrigin:CGPoint{
        
        let mvFrame = UIScreen.main.bounds
        //x 区间大小（0...x_max）
        let x_max = mvFrame.width - self.frame.size.width
        //y 区间大小（0...y_max）
        let y_max = mvFrame.height - self.frame.size.height
        
        //随机区间 ＝ 区间最小值 + 随机值
        let x_random = arc4random() % UInt32(x_max)
        let y_random = arc4random() % UInt32(y_max)
        //随机坐标 : xy坐标为控件的左上角(0,0)所以不用作一下计算
        //            let x = x_random + UInt32(self.frame.size.width)
        //            let y = y_random + UInt32(self.frame.size.height)
        print("水印坐标：x = \(x_random),Y = \(y_random)")
        return CGPoint(x: CGFloat(x_random), y: CGFloat(y_random))
        
    }
    
    //static var shadeTimer:NSTimer?
    public func fireTimer()->()->()
    {
        //默认显示，24s之后隐藏
        let timer = Timer(timeInterval: 24.0, target: self, selector: #selector(UILabel.hidden), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        return {
            timer.invalidate()
        }
    }
    
    func hidden()
    {
        //
        UIView.animate(withDuration: 2.0, animations: {
            self.alpha = 0
            self.isHidden = true
            }, completion: { completion in
                
                if completion
                {
                    print("\(Date())水印隐藏....")
                    //隐藏20秒之后，再显示出来
                    Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(UILabel.show), userInfo: nil, repeats: false)
                }
        })
        
    }
    
    func show()
    {
        //动画
        UIView.animate(withDuration: 1.0, animations: {
            //
            self.isHidden = false
            self.alpha = 1
            self.frame.origin = self.shadeOrigin
            
            }, completion: {completion in
                print("\(Date())水印显示....")
        })
    }
}

//NSTimer.eve(5.secends){}
//http://radex.io/swift/nstimer/
extension Timer
{
    //定义一个嵌套类型，实现闭包的在NSTimer中接收和执行
    class NSTimerActor
    {
        //存储变量是闭包类型
        var block:()->()
        //构造器
        init(_ block:@escaping ()->())
        {
            self.block = block
        }
        
        /**
         This is a bridge between the closure-based API and the target/selector reality. We can initialize this object with a closure, and then call fire to run it. (The fire method needs to be @objc to work with NSTimer.)
         */
        //执行block闭包程序
        @objc func fire()
        {
            self.block()
        }
    }
    
    /**
     Wait, wait, wait… class func new? That’s not an initializer! No, it’s not, but unfortunately, as of Swift 1.2, there’s a bug (18720947) that will crash this code if we define it as a convenience initializer. Calling this new seems like a reasonable compromise.
     we can define every and after in terms of new
     */
    
    //扩展构造器
    class func new(after interval:TimeInterval,_ block:@escaping ()->())->Timer
    {
         //闭包接收器
        let timerActor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: timerActor, selector: #selector(timerActor.fire), userInfo: nil, repeats: false)
    }
    
    class func new(every interval:TimeInterval,_ block:@escaping ()->())->Timer
    {
        let timerActor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: timerActor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: true)
    }
    
    //time分钟后执行一次
    public class func after(_ time:TimeInterval,_ block:@escaping ()->())->Timer
    {
        let timer = Timer.new(after:time,block)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        return timer
    }

    //每隔time执行一次
    public class func every(_ time:TimeInterval,_ block:@escaping ()->())->Timer
    {
        let timer = Timer.new(every: time, block)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        return timer
    }
    
}
