//: [Previous](@previous)


//[UIBezierPath精讲](http://www.jianshu.com/p/734b34e82135)
import Foundation
import UIKit

// 画三角形
func drawTrianglePath() {
    
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(20, 20))
    path.addLineToPoint(CGPointMake(50, 50))
    path.addLineToPoint(CGPointMake(10, 80))
    // 最后的闭合线是可以通过调用closePath方法来自动生成的，也可以调用-addLineToPoint:方法来添加
    //  [path addLineToPoint:CGPointMake(20, 20)];
    path.closePath()
    
    // 设置线宽
    path.lineWidth = 1.5;
    
    // 设置填充颜色
    UIColor.darkGrayColor().setFill()
    path.fill()
    
    // 设置画笔颜色
    //如果要让填充颜色与画笔颜色不一样，那么我们的顺序必须是先设置填充颜色再设置画笔颜色
    UIColor.blueColor().set()
    
    // 根据我们设置的各个点连线
    path.stroke()
}

drawTrianglePath()


//画矩形
func drawRectPath(){
    
    let path = UIBezierPath.init(rect: CGRectMake(20, 20, 200, 200))
    
    path.lineWidth = 10
    path.lineCapStyle = .Round
    path.lineJoinStyle = .Bevel
    //设置填充色
    UIColor.yellowColor().setFill()
    path.fill()
    //设置画笔色
    UIColor.redColor().set()
    
    path.stroke()

}

drawRectPath()



//: [Next](@next)
