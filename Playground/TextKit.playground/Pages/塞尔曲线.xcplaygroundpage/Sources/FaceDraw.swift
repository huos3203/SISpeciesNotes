import Foundation
import UIKit
///绘制笑脸:实做出这三个方法：绘制脸、绘制眼睛与绘制嘴巴
/*
  //通过 oval（椭圆形）绘制眼睛,绘制脸
    //通过 arc（弧形线）绘画眼睛
 
    oval（椭圆形）:在指定的正方形上，以顺时针的方向，沿着正方形绘画出一个封闭式的椭圆形塞尔曲线路径。即：如果矩形参数指定了一个正方形，内接的路径是一个圆。
    arc（弧形线）：在指定的圆形上，以顺时/逆时针方向，沿着圆形周边绘画一段区间弧度的开放式弧形塞尔曲线路径。
    addCurve（赛尔曲线）：该方法为Path添加一个赛尔曲线：包含两个控制点一个是当前点，一个是由参数指定的终点。这两控制点声明了曲线段的曲率。
            设置当前点：在调用addCurve方法之前必须先设置。有两种方式：
                        1. 通过move(to:)设置当前点
                        2. 从之前已创建的line／curve段上的点设置为当前点
         addCurve调用：当Path调用addCurve方法之后，会把当前点（move设置）移动到 to:指定的新位置点上。如果Path为空，点用addCurve方法不起作用
 stroke()：在Path自定义完成后，开始绘制。
 */
public class FaceDraw: UIView {
    //
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //绘制脸
    func drawHead(){ 
    
        /*
            此方法是在（相对于默认坐标系统）UIBezierPath以顺时针方向绘画出一个接近序列塞尔曲线的椭圆形的封闭式路径。即：如果矩形参数指定了一个正方形，内接的路径是一个圆。
         */
        let headPath = UIBezierPath.init(ovalIn: CGRect.init(x: 40, y: 120, width: 240, height: 240))
        headPath.lineWidth = 5
        headPath.stroke()
    }
    
    //通过 oval（椭圆形）绘制眼睛
    func drawEyesByOval(){
    
        let leftEyePath = UIBezierPath.init(ovalIn: CGRect.init(x: 115, y: 190, width: 10, height: 10))
        leftEyePath.lineWidth = 5
        leftEyePath.stroke()
        
        //复制移动到右眼位置,画圆形时，系统没有提供移动后再画的方法
        //leftEyePath.moveToPoint(CGPointMake(215, 190))
        let rightEyePath = UIBezierPath.init(ovalIn: CGRect.init(x: 215, y: 190, width: 10, height: 10))
        rightEyePath.lineWidth = 5
        rightEyePath.stroke()
    }
    
    //通过 arc（弧形线）绘画眼睛
    func drawEyesByARC() {
        //
        let arcPath = UIBezierPath()
        //左眼
        arcPath.addArc(withCenter: CGPoint.init(x: 115, y: 190),
                         radius: 10,
                     startAngle: 0,
                       endAngle: CGFloat(M_PI * 2),
                      clockwise: true)
        
        arcPath.lineWidth = 5
        arcPath.stroke()
        //右眼,落笔前必须先移动到最新位置，再画出右眼
        arcPath.move(to: CGPoint.init(x: 215, y: 190))
        arcPath.addArc(withCenter: CGPoint.init(x: 205, y: 190),
                         radius: 10,
                     startAngle: 0,
                       endAngle: CGFloat(M_PI * 2),
                      clockwise: true)
        arcPath.stroke()
    }
    
    
    //绘制微笑
    func drawSmile(){
    
        let smile = UIBezierPath()
        //移动至坐标点
        smile.move(to: CGPoint(x:100, y:280))
        smile.addCurve(to: CGPoint(x:220, y:280),
                       controlPoint1: CGPoint(x:130, y:330),
                       controlPoint2: CGPoint(x:190, y:330))
        
        smile.lineWidth = 5
        smile.stroke()
    }
    
    
    public override func draw(_ rect: CGRect) {

        //设定所画出的 Path 颜色
        UIColor.yellow.set()
        
        drawHead()
//        drawEyesByOval()
        drawEyesByARC()
        drawSmile()
    }
}



