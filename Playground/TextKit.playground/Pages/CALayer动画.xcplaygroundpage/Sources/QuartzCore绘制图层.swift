import Foundation

import UIKit
public class drawLayerViewController: UIViewController {
    //
    
    override public func viewDidLoad() {
        //
        let layer = DrawLayer.DrawLayer(CGRectMake(0, 0, 100, 100))
        view.layer.addSublayer(layer)
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //
        let touch = touches.first
        let layer = view.layer.sublayers![0]
        var width = layer.bounds.size.width
        if width == 50 {
            width = 50 * 4
        }else
        {
            width = 50
        }
        
        layer.bounds = CGRectMake(0, 0, width, width)
        layer.position = (touch?.locationInView(self.view))!
        layer.cornerRadius = width/2
    }
}
/// 1. CALayer中透明度使用opacity表示而不是alpha；中心点使用position表示而不是center。
/// 2. anchorPoint属性是图层的锚点，范围在（0~1,0~1）表示在x、y轴的比例，这个点永远可以同position（中心点）重合，当图层中心点固定后，调整anchorPoint即可达到调整图层显示位置的作用（因为它永远和position重合）

///  3. 在CALayer中很少使用frame属性，因为frame本身不支持动画效果，通常使用bounds和position代替。

/// 说明anchorPoint的作用，假设有一个层大小100*100，现在中心点位置（50,50），由此可以得出frame（0,0,100,100）。上面说过anchorPoint默认为（0.5,0.5），同中心点position重合，此时使用图形描述如图1；当修改anchorPoint为（0,0），此时锚点处于图层左上角，但是中心点poition并不会改变，因此图层会向右下角移动，如图2；然后修改anchorPoint为（1,1,），position还是保持位置不变，锚点处于图层右下角，此时图层如图3。
//Quartz 2D绘制图层
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