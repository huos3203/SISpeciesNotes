import Foundation
import UIKit
///绘制笑脸:实做出这三个方法：绘制脸、绘制眼睛与绘制嘴巴

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
    
        let headPath = UIBezierPath.init(ovalInRect: CGRectMake(40, 120, 240, 240))
        headPath.lineWidth = 5
        headPath.stroke()
    }
    
    //绘制眼睛
    func drawEyesByOval(){
    
        let leftEyePath = UIBezierPath.init(ovalInRect: CGRectMake(115, 190, 10, 10))
        leftEyePath.lineWidth = 5
        leftEyePath.stroke()
        
        //复制移动到右眼位置,画圆形时，系统没有提供移动后再画的方法
        //leftEyePath.moveToPoint(CGPointMake(215, 190))
        let rightEyePath = UIBezierPath.init(ovalInRect: CGRectMake(215, 190, 10, 10))
        rightEyePath.lineWidth = 5
        rightEyePath.stroke()
    }
    
    func drawEyesByARC() {
        //
        let arcPath = UIBezierPath()
        //左眼
        arcPath.addArcWithCenter(CGPointMake(115, 190), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        arcPath.lineWidth = 5
        arcPath.stroke()
        //右眼,落笔前必须先移动到最新位置，再画出右眼
        arcPath.moveToPoint(CGPointMake(215, 190))
        arcPath.addArcWithCenter(CGPointMake(205, 190), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        arcPath.stroke()  
    }
    
    
    //绘制微笑
    func drawSmile(){
    
        let smile = UIBezierPath()
        //移动至坐标点
        smile.moveToPoint(CGPointMake(100, 280))
        smile.addCurveToPoint(CGPointMake(220, 280), controlPoint1: CGPointMake(130, 330), controlPoint2: CGPointMake(190, 330))
        
        smile.lineWidth = 5
        smile.stroke()
    }
    
    
    public override func drawRect(rect: CGRect) {

        //设定所画出的 Path 颜色
        UIColor.yellowColor().set()
        
        drawHead()
//        drawEyesByOval()
        drawEyesByARC()
        drawSmile()
    }
}



