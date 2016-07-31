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
    override func drawRect(rect: CGRect) {
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

let view = pathView(frame: CGRectMake(20, 20, 300, 300))


//绘画笑脸
let faceView = FaceDraw(frame:CGRectMake(0, 0, 400, 400))
//
//XCPlaygroundPage.currentPage.liveView = DownLoadViewController()




//: [Next](@next)
