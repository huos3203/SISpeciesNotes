import Foundation

import UIKit


//继承UIView实现一个进度条，通道层，进度层，通道Path /颜色，进度Path /颜色, 进度

public class CircleProgressView: UIView {
    
    //loading管层
    private var trackLayer:CAShapeLayer!
    private var trackPath:UIBezierPath!
    public var trackPathWidth:CGFloat = 10
    //loading液柱层
    private var progressLayer:CAShapeLayer!
    private var progressPath:UIBezierPath!
    public var progressColor:UIColor = UIColor.yellow
    
    //在loading观察属性中绘制液柱loading液柱层
    public var progress:Double = 0{
        didSet(oldValue)
        {
            print("-----------进度:\(progress)")
            drawProgressPath()
        }
    }

    //构造loadingView视图样式
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        //
        backgroundColor = UIColor.blue
        /*
             CAShapeLayer：在它的坐标空间中绘制3D塞尔曲线，绘制形状介于layer的内容和第一个子layer之间。
                    这个形状会被绘制成反锯齿，尽可能在被栅格化之前映射在屏幕上，以排除分辨率的原因。
            */
        trackLayer = CAShapeLayer()
        self.layer.addSublayer(trackLayer)
        //务必设置frame ＝ bounds，progressLayer错位，以及画弧线时，使用center坐标会错位
        trackLayer.frame = bounds
        //务必设置填充为nil
        trackLayer.fillColor = nil
        
        progressLayer = CAShapeLayer()
        self.layer.addSublayer(progressLayer)
        //务必设置frame ＝ bounds，progressLayer错位，以及画弧线时，使用center坐标会错位
        progressLayer.frame = bounds
        //务必设置填充为nil
        progressLayer.fillColor = nil
        //进度条会以 圆头样式 注满trackPath
        progressLayer.lineCap = kCALineCapRound
       
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect)
    {
        //绘制通道和进度条
        drawTrackPath()
        drawProgressPath()
    }
   
    //Path通道
    func drawTrackPath()
    {
        //画弧线
        let centerXY = CGPoint.init(x:frame.width/2,y:frame.height/2)
        let radius = (bounds.width - trackPathWidth)/2
        /*
         UIBezierPath以centerXY圆心以radius为半径，从0弧度角顺时针绘画到360弧度角，形成一个圆形状
         */
        trackPath = UIBezierPath.init(arcCenter: centerXY,
                                      radius: radius,
                                      startAngle: 0.degreesToRadians,
                                      endAngle:CGFloat(M_PI * 2),
//                                      endAngle: 360.degreesToRadians,
                                      clockwise: true)
        
        trackLayer.path = trackPath.cgPath
        trackLayer.lineWidth = trackPathWidth
        trackLayer.strokeColor = UIColor.green.cgColor
    }
    
    func drawProgressPath()
    {
        let centerXY = CGPoint(x:frame.width/2,y:frame.height/2)
        let radius = (bounds.width - trackPathWidth)/2
        let startAngle = CGFloat(-M_PI_2)
        /*
            This method creates an open subpath
            赛尔曲线以centerXY圆心以radius为半径，从-90弧度角顺时针绘画到progress - 90弧度角，形成一个弧形圆
            progress是变量，来自滑动条的值（0~360）
         */
        progressPath = UIBezierPath.init(arcCenter: centerXY,
                                         radius: radius,
            //                                         startAngle:startAngle,
            //                                         endAngle: CGFloat((M_PI * 2) * progress - M_PI_2),  //适用于：0~1 (90度为起点)
                                         startAngle:-90.degreesToRadians,
                                         endAngle:(progress - 90).degreesToRadians,  //适用于：0～360(90度为起点)
                                         clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.lineWidth = trackPathWidth
        progressLayer.strokeColor = progressColor.cgColor
    }
}
