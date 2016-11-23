//: [Previous](@previous)

//[UIBezierPath精讲](http://www.jianshu.com/p/734b34e82135)
import Foundation
import UIKit
import XCPlayground


class pathView: UIView {
    //
    override init(frame: CGRect) {
        //
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        //
//        drawRectPath(rect)
//        drawCiclePath(rect)
//        drawOvalPath(rect)
//        drawRoundRectPath(rect)
        drawARCPath(rect)
//        drawSecondBezierPath()
//        drawThirdBezierPath()
    }

}

let view = pathView(frame: CGRect.init(x: 20, y: 20, width: 300, height: 300))

//绘画笑脸
let faceView = FaceDraw(frame:CGRect.init(x: 0, y: 0, width: 400, height: 400))
XCPlaygroundPage.currentPage.liveView = faceView
/*
    MARK: 绘制进度条
    拖动滑动条，演示loading动画
 */
public class DownLoadViewController:UIViewController
{
    
    private var progress:UISlider!
    private var progressView:CircleProgressView!
    public override func viewDidLoad()
    {
        //声明滑动条
        progress = UISlider.init(frame: CGRect.init(x: 20, y: 100, width: 300, height: 5))
        progress.maximumValue = 360
        progress.minimumValue = 0
        progress.addTarget(self, action: #selector(DownLoadViewController.slider), for: .valueChanged)
        view.addSubview(progress)
        
        progressView = CircleProgressView.init(frame: CGRect.init(x: 20, y: 150, width: 200, height: 200))
        view.addSubview(progressView)
        //loading液的颜色
        progressView.progressColor = UIColor.red
        //loading管的宽
        progressView.trackPathWidth = 30
        //演示台的背景色
        view.backgroundColor = UIColor.white
    }
    
    //滑动条值的改变，显示在loading上
    func slider()
    {
        progressView.progress = Double(progress.value)
    }
}

//XCPlaygroundPage.currentPage.liveView = DownLoadViewController()


//: [Next](@next)
