//
//  Label+shadeAnimation.swift
//  PBB
//
//  Created by pengyucheng on 16/4/5.
//  Copyright © 2016年 pyc.com.cn. All rights reserved.
//
import Cocoa

extension NSTextField
{
    var shadeOrigin:CGPoint{
        guard let mvFrame = superview?.bounds
        else
        {
            return CGPointMake(0,0);
        }
        //x 区间大小（0...x_max）
        let x_max = mvFrame.width - self.frame.size.width
        //y 区间大小（0...y_max）
        let y_max = mvFrame.height - self.frame.size.height - 100
        //随机区间 ＝ 区间最小值 + 随机值
        let x_random = arc4random() % UInt32(x_max)
        let y_random = arc4random() % UInt32(y_max) + 60
        //随机坐标 : xy坐标为控件的左上角(0,0)所以不用作一下计算
        //            let x = x_random + UInt32(self.frame.size.width)
        //            let y = y_random + UInt32(self.frame.size.height)
//        print("水印坐标：x = \(x_random),Y = \(y_random)")
        return CGPointMake(CGFloat(x_random), CGFloat(y_random))
    }
    
    //秒
    var second:NSTimeInterval{
        set{
        }
        get{
            return self.second
        }
    }
    //分
    var minute:NSTimeInterval{
        set(newValue){
        }
        get{
            return self.minute
        }
    }
    
    public func fireTimer(Countdown:Double)->()->()
    {
        var timer:NSTimer!
        if Countdown == 0 {
            //默认显示，24s之后隐藏
            timer = NSTimer(timeInterval: 24.0, target: self, selector: #selector(NSTextField.hidden as (NSTextField) -> () -> ()), userInfo: nil, repeats: true)
        }else{
    
            if let mvFrame = superview?.bounds {
                self.frame.origin = CGPointMake(CGFloat(mvFrame.width/2), CGFloat(0))
            }else{
                self.frame.origin = CGPointMake(CGFloat(100), CGFloat(0))
            }

            self.minute = Countdown / 60
            self.second = Countdown % 60

            timer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(NSTextField.Countdown), userInfo: nil, repeats: true)
        }
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        //匿名函数
       return {
            self.animator().alphaValue = 1
            self.hidden = false
            timer.invalidate()
            Swift.print("关闭隐藏动画....")
        }
    }

    func Countdown() {
        //
        var time = 10
        self.stringValue = "\(second) s"
        if (time > 0) {
            if (second<0) {
                minute = minute - 1
                second = 60
            }
            if (minute == 0) {
                second = second - 1
                self.stringValue = "\(second)秒"
                //背景色
                if (second < 10) {
                    self.animator().alphaValue = 0.3
                    self.backgroundColor = NSColor.redColor()
                    if (second < 0) {
                        //关闭播放器
//                        NSNotificationCenter.defaultCenter().postNotificationName("CancleClosePlayerWindows", object: nil)
                    }
                }
            } else {
                self.stringValue = "\(minute)分\(second)秒"
            }
        }
    }
    
    func hidden()
    {
        //
        NSAnimationContext.runAnimationGroup({ (context) in
            //
            context.duration = 1.0
            self.hidden = true
            self.animator().alphaValue = 0
            
        }) {
//            print("\(NSDate())水印隐藏....")
            //隐藏20秒之后，再显示出来
            NSTimer.scheduledTimerWithTimeInterval(18.0, target: self, selector: #selector(NSTextField.show), userInfo: nil, repeats: false)
        }

    }
    
    func show()
    {
        //动画
        NSAnimationContext.runAnimationGroup({ (context) in
            //
            context.duration = 1.0
            self.hidden = false
            self.animator().alphaValue = 1
            self.animator().setFrameOrigin(self.shadeOrigin)
            
            }) { 
//                print("\(NSDate())水印显示....")
        }
    }
}