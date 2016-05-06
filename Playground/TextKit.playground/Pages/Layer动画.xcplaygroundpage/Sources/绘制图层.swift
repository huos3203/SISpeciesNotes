import Foundation

import UIKit

//绘制图层
public class DrawLayer {
    //
    class public func DrawLayer(frame:CGRect)->CALayer{
        
        let layer = CALayer.init()
        //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
        layer.backgroundColor = UIColor.blueColor().CGColor
        //设置中心点
        layer.position = CGPointMake(frame.width/2, frame.height/2)
        //设置大小
        layer.bounds = CGRectMake(0, 0, 50, 50)
        //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
        layer.cornerRadius = frame.width/2
        //设置阴影
        layer.shadowColor = UIColor.darkGrayColor().CGColor
        layer.shadowOffset = CGSizeMake(2, 2)
        layer.shadowOpacity = 0.9
        //设置边框
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1
        //设置锚点
        layer.anchorPoint = CGPointZero
        return layer
    }
}