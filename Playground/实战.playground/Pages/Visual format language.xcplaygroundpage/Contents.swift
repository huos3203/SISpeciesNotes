//: [Previous](@previous)

import Foundation
import XCPlayground
import UIKit

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let leftitem = UIBarButtonItem()
let button2 = UIButton()
let white = UIView.init(frame: CGRectMake(0, 0, 20, 50))
white.backgroundColor = UIColor.blackColor()
class viewController: UIViewController {
    //
    var hideGuideItem:(UIButton)->() = {_ in }
    
    override func viewDidLoad() {
        //
        let viewShade = UIView()
        view.addSubview(viewShade)
        viewShade.addGuideShadeToFullScreen()
        
        viewShade.backgroundImageView = UIImageView(image: [#Image(imageLiteral: "beijing-thumb@3x.jpg")#])
        let btn1 = UIButton()
        btn1.setImage([#Image(imageLiteral: "barcelona-thumb@2x.jpg")#], forState: .Normal)
        viewShade.leftItem = btn1
//        btn1.addTarget(self, action: #selector(viewController.hiddenItem(_:)), forControlEvents: .TouchDown)
//        btn1.sizeToFit()
        
        let btn2 = UIButton()
        btn2.setImage([#Image(imageLiteral: "barcelona-thumb@3x.jpg")#], forState: .Normal)
        viewShade.rightItem = btn2
//        btn2.addTarget(self, action: #selector(viewController.hiddenItem(_:)), forControlEvents: .TouchDown)
//        btn2.sizeToFit()
        setNavgationItem()
    }
    
    func hiddenItem(item:UIButton) {
        //
        hideGuideItem(item)
    }
    //使用VFL语法来布局控件
    
    //设置导航条
    func setNavgationItem(){
        //To change the contents of the navigation bar, you must therefore configure the navigation items of your custom view controllers. For more information about navigation items
        
        leftitem.title = "left"
        leftitem.tintColor = UIColor.blackColor()
//        leftitem.setBackgroundImage([#Image(imageLiteral: "barcelona-thumb@2x.jpg")#], forState: .Normal, barMetrics: .Compact)
        
        let rightitem = UIBarButtonItem.init(customView: white)
        rightitem.title = "right"
        rightitem.tintColor = UIColor.blackColor()
        
        self.navigationItem.titleView?.backgroundColor = UIColor.blackColor()
//        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.setLeftBarButtonItem(leftitem, animated: true)
        self.navigationItem.setRightBarButtonItem(rightitem, animated: false)
    }
}



let nav = UINavigationController.init(rootViewController: viewController())



XCPlaygroundPage.currentPage.liveView = nav


//XCPlaygroundPage.currentPage.captureValue(leftitem, withIdentifier: "left")
//XCPlaygroundPage.currentPage.captureValue(white.frame, withIdentifier: "button2")
//: [Next](@next)
