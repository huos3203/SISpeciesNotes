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
    override func viewDidLoad() {
        //
        let button = UIButton()
        button.backgroundColor = UIColor.yellowColor()
        
        
        view.addSubview(button)
        view.backgroundColor = UIColor.whiteColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        //垂直布局  NSDictionaryOfVariableBindings
        let Vconstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[button(==30)]", options: [], metrics: nil, views: ["button" : button])
        let Hconstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button]-|", options: [], metrics: nil, views: ["button" : button])
        view.addConstraints(Vconstraint)
        view.addConstraints(Hconstraint)
        
        
        button2.backgroundColor = UIColor.brownColor()
        view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        let Hconstraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button2(==30)]-|", options: [], metrics: nil, views: ["button":button,"button2":button2])
        let Vconstraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-20-[button2(==30)]", options: [], metrics: nil, views: ["button":button,"button2":button2])
        view.addConstraints(Hconstraints2)
        view.addConstraints(Vconstraints2)
        
        setNavgationItem()
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


XCPlaygroundPage.currentPage.captureValue(leftitem, withIdentifier: "left")
XCPlaygroundPage.currentPage.captureValue(white.frame, withIdentifier: "button2")
//: [Next](@next)
