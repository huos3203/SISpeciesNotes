//: [Previous](@previous)

import Foundation

import UIKit
import XCPlayground
//http://www.cocoachina.com/ios/20141022/10005.html
class drawLayerViewController: UIViewController {
    //
    
    override func viewDidLoad() {
        //
        let layer = DrawLayer.DrawLayer(CGRectMake(0, 0, 100, 100))
        view.layer.addSublayer(layer)
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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

//XCPlaygroundPage.currentPage.liveView = drawLayerViewController()


XCPlaygroundPage.currentPage.liveView = DrawRoundPhoto()

//: [Next](@next)
