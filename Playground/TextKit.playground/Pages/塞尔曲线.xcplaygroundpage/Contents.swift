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
//
XCPlaygroundPage.currentPage.liveView = faceView
    //DownLoadViewController()




//: [Next](@next)
