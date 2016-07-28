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
    
//    @objc static var shadeTimer:NSTimer?

    func fireTimer()->()->()
    {
        //默认显示，24s之后隐藏
        let timer = NSTimer(timeInterval: 24.0, target: self, selector: #selector(NSTextField.hidden as (NSTextField) -> () -> ()), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        //匿名函数
       return {
            self.animator().alphaValue = 1
            self.hidden = false
            timer.invalidate()
//            print("关闭隐藏动画....")
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