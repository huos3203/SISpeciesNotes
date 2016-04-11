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
        
        let mvFrame = UIScreen.mainScreen().bounds
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
        return CGPointMake(CGFloat(x_random), CGFloat(y_random))
        
    }
    
//    static var shadeTimer:NSTimer?
    
    func fireTimer()->()->()
    {
        //默认显示，24s之后隐藏
        let timer = NSTimer(timeInterval: 24.0, target: self, selector: #selector(UILabel.hidden), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        return {
            timer.invalidate()
        }
    }
    
    func hidden()
    {
        //
        UIView.animateWithDuration(2.0, animations: {
            self.alpha = 0
            self.hidden = true
            }){ completion in
                
                if completion
                {
                    print("\(NSDate())水印隐藏....")
                    //隐藏20秒之后，再显示出来
                    NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(UILabel.show), userInfo: nil, repeats: false)
                }
        }
        
    }
    
    func show()
    {
        //动画
        UIView.animateWithDuration(1.0, animations: {
            //
            self.hidden = false
            self.alpha = 1
            self.frame.origin = self.shadeOrigin
            
            }){completion in
                print("\(NSDate())水印显示....")
        }
    }
}