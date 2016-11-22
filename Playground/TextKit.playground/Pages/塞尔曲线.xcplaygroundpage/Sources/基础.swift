import Foundation

import UIKit
// 画三角形
public func drawTrianglePath() {
    
    //1. 创建一个UIBezierPath对象
    let path = UIBezierPath()
    //2. 调用-moveToPoint:设置初始线段的起点
    path.move(to: CGPoint.init(x: 20, y: 20))
    //3. 添加线或者曲线去定义一个或者多个子路径
    path.addLine(to: CGPoint.init(x:50, y:50))
    path.addLine(to: CGPoint.init(x:10, y:80))
    // 最后的闭合线是可以通过调用closePath方法来自动生成的，也可以调用-addLineToPoint:方法来添加
    //  [path addLineToPoint:CGPointMake(20, 20)];
    path.close()
    
    
    //4. 改变UIBezierPath对象跟绘图相关的属性。如，我们可以设置画笔的属性、填充样式等
    // 设置线宽
    path.lineWidth = 1.5;
    
    // 设置填充颜色
    UIColor.darkGray.setFill()
    path.fill()
    
    // 设置画笔颜色
    //如果要让填充颜色与画笔颜色不一样，那么我们的顺序必须是先设置填充颜色再设置画笔颜色
    UIColor.blue.set()
    
    // 根据我们设置的各个点连线
    path.stroke()
}

//画矩形
public func drawRectPath(_ frame:CGRect){
    
    let path = UIBezierPath.init(rect: frame)
    //改变UIBezierPath对象跟绘图相关的属性。如，我们可以设置画笔的属性、填充样式等
    path.lineWidth = 20
    //lineCapStyle属性是用来设置线条拐角帽的样式的，其中有三个选择：
    //Butt:第一个是默认的，Round:轻微圆角，Square:正方形。
    path.lineCapStyle = .butt
    //lineJoinStyle属性是用来设置两条线连结点的样式，其中也有三个选择
    //Miter:默认的表示斜接，Round:圆滑衔接，Bevel:斜角连接。
    path.lineJoinStyle = .round
    //设置填充色
    UIColor.yellow.setFill()
    path.fill()
    //设置画笔色
    UIColor.red.set()
    
    path.stroke()
    
}


//画圆形:要画圆，我们需要传的rect参数必须是正方形哦！
 public func drawCiclePath(_ frame:CGRect){
    
    //创建实例
    let path = UIBezierPath.init(ovalIn: frame)
    
    //设置线条样式
    path.lineWidth = 1.5
    
    //填充色
    UIColor.brown.setFill()
    path.fill()
    
    //画笔色
    UIColor.red.set()
    path.stroke()
}

//画椭圆形:需要传的rect参数必须是长方形
public func drawOvalPath(_ frame:CGRect){
    
    let path = UIBezierPath.init(ovalIn: frame)
    
    //fill color
    UIColor.cyan.setFill()
    path.fill()
    
    //画笔色
    UIColor.darkGray.set()
    path.stroke()
}


//画带有圆角的矩形：四角全是圆角、指定其中一角为圆角
public func drawRoundRectPath(_ frame:CGRect){
    
    //第一个参数是矩形，第二个参数是圆角大小。
    //    let path = UIBezierPath.init(roundedRect: frame, cornerRadius: 20)
    
    //可以指定某一个角画成圆角。
    //其中第一个参数是矩形，第二个参数是指定在哪个方向画圆角，第三个参数是一个CGSize类型，用来指定水平和垂直方向的半径的大小
    let path = UIBezierPath.init(roundedRect: frame,
                         byRoundingCorners: .topRight,
                               cornerRadii: CGSize.init(width: 20, height: 20))
    UIColor.red.setFill()
    path.fill()
    
    path.lineWidth = 10
    UIColor.blue.set()
    path.stroke()
}



//画圆弧
/**
 画弧参数startAngle和endAngle使用的是弧度，而不是角度，因此我们需要将常用的角度转换成弧度。对于效果图中，我们设置弧的中心为控件的中心，起点弧度为0，也就是正东方向，而终点是135度角的位置。
 1. 如果设置的clockwise:YES是逆时针方向绘制：
 ![](http://upload-images.jianshu.io/upload_images/1255547-479c3e62e7ae42af.jpg?imageMogr2/auto-orient/strip%7CimageView2/2)，
 2. 如果设置为NO顺时针方向绘制：
 ![](http://upload-images.jianshu.io/upload_images/1255547-034eae4657f68d86.jpg?imageMogr2/auto-orient/strip%7CimageView2/2)
 
 */

public func drawARCPath(_ frame:CGRect){
    
    //center
    let center = CGPoint(x:frame.width/2, y:frame.height/2)
    //path
    let path = UIBezierPath.init(arcCenter: center,
                                 radius: 100,
                                 startAngle: 0,
                                 endAngle: -180,//.degreesToRadians,
                                 clockwise: false)
    path.lineCapStyle = .round
    path.lineJoinStyle = .round
    path.lineWidth = 5
    
    //画圆弧不需要填充颜色，否则就画成半圆形
    //    UIColor.blueColor().setFill()
    //    path.fill()
    
    UIColor.red.set()
    path.stroke()
}


//画二次贝塞尔曲线
/**
 画二次贝塞尔曲线的步骤：
 
 1. 先设置一个起始点，也就是通过-moveToPoint:设置
 2. 调用-addQuadCurveToPoint:controlPoint:方法设置终端点和控制点，
 ![](http://upload-images.jianshu.io/upload_images/1255547-99c1c61130607358.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 */
public func drawSecondBezierPath(){
    
    let path = UIBezierPath()
    
    //设置起点
    path.move(to: CGPoint.init(x: 80, y: 20))
    
    //添加二次曲线
    // endPoint： 终端点
    //controlPoint：控制点，对于二次贝塞尔曲线，只有一个控制点
    path.addQuadCurve(to: CGPoint.init(x: 80, y: 80), controlPoint: CGPoint.init(x: 10, y: 20))
    
    path.lineWidth = 10
    path.lineJoinStyle = .round
    path.lineCapStyle = .round
    
    UIColor.red.set()
    path.stroke()
}

//画三次贝塞尔曲线:其组成是起始端点+控制点1+控制点2+终止端点
/**
 贝塞尔曲线必定通过首尾两个点，称为端点；中间两个点虽然未必要通过，但却起到牵制曲线形状路径的作用，称作控制点。关于三次贝塞尔曲线的控制器，看下图：![](http://upload-images.jianshu.io/upload_images/1255547-2b7dbc9b577e6d57.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2)
 
 */
public func drawThirdBezierPath() {
    //
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x:20, y:150))
    path.addCurve(to: CGPoint(x:300, y:150),
                  controlPoint1: CGPoint(x:160, y:0),
                  controlPoint2: CGPoint(x:160, y:250))
    
    path.lineWidth = 10
    path.lineCapStyle = .round
    path.lineJoinStyle = .round
    
    UIColor.red.set()
    path.stroke()
}
