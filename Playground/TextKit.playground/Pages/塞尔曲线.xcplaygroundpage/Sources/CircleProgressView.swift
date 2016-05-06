import Foundation

import UIKit


//继承UIView实现一个进度条，通道层，进度层，通道Path /颜色，进度Path /颜色, 进度

public class CircleProgressView: UIView {
    
    //layer
    private var trackLayer:CAShapeLayer!
    private var progressLayer:CAShapeLayer!
    //Path
    private var trackPath:UIBezierPath!
    private var progressPath:UIBezierPath!
    
    
    public var progress:Double = 0{
        
        didSet(oldValue){
            print("-----------进度:\(progress)")
            drawProgressPath()
        }
    
    }
    
    public var trackPathWidth:CGFloat = 10
    public var progressColor:UIColor = UIColor.yellowColor()
    
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        //
        backgroundColor = UIColor.blueColor()
        
        trackLayer = CAShapeLayer()
        self.layer.addSublayer(trackLayer)
        //务必设置frame ＝ bounds，progressLayer错位，以及画弧线时，使用center坐标会错位
        trackLayer.frame = bounds
        //务必设置填充为nil
        trackLayer.fillColor = nil
        
        progressLayer = CAShapeLayer()
        self.layer.addSublayer(progressLayer)
        //务必设置填充为nil
        progressLayer.fillColor = nil
        //进度条会以 圆头样式 注满trackPath
        progressLayer.lineCap = kCALineCapRound
        //务必设置frame ＝ bounds，progressLayer错位，以及画弧线时，使用center坐标会错位
        progressLayer.frame = bounds
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawRect(rect: CGRect) {
        //绘制通道和进度条
        drawTrackPath()
        drawProgressPath()
    }
   
    //Path
    func drawTrackPath() {
        //画弧线
        let radius = (bounds.width - trackPathWidth)/2
        let centerXY = CGPointMake(frame.width/2,frame.height/2)
        trackPath = UIBezierPath.init(arcCenter: centerXY,
                                      radius: radius,
                                      startAngle: 0.degreesToRadians,
                                      endAngle:CGFloat(M_PI * 2),
//                                      endAngle: 360.degreesToRadians,
                                      clockwise: true)
        
        trackLayer.path = trackPath.CGPath
        trackLayer.lineWidth = trackPathWidth
        trackLayer.strokeColor = UIColor.greenColor().CGColor
    }
    
    func drawProgressPath() {

        let centerXY = CGPointMake(frame.width/2,frame.height/2)
        let radius = (bounds.width - trackPathWidth)/2
        let startAngle = CGFloat(-M_PI_2)
        progressPath = UIBezierPath.init(arcCenter: centerXY,
                                         radius: radius,
//                                         startAngle:startAngle,
//                                         endAngle: CGFloat((M_PI * 2) * progress - M_PI_2),  //适用于：0~1 (90度为起点)
                                         startAngle:-90.degreesToRadians,
                                         endAngle:(progress - 90).degreesToRadians,  //适用于：0～360(90度为起点)
                                         clockwise: true)
        
        progressLayer.path = progressPath.CGPath
        progressLayer.lineWidth = trackPathWidth
        progressLayer.strokeColor = progressColor.CGColor
    }
}


public class DownLoadViewController:UIViewController{

    private var progress:UISlider!
    private var progressView:CircleProgressView!
    public override func viewDidLoad() {
        //
        progress = UISlider.init(frame: CGRectMake(20, 100, 300, 5))
        progress.maximumValue = 360
        progress.minimumValue = 0
        progress.addTarget(self, action: "slider", forControlEvents: .ValueChanged)
        view.addSubview(progress)
        
        progressView = CircleProgressView.init(frame: CGRectMake(20, 150, 200, 200))
        view.addSubview(progressView)
        progressView.progressColor = UIColor.redColor()
        progressView.trackPathWidth = 30
        
        view.backgroundColor = UIColor.whiteColor()
        
    }

    func slider() {
        //
        
        progressView.progress = Double(progress.value)
    }
    
}