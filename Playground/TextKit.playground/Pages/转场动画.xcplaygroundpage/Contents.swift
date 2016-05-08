//: [Previous](@previous)

import Foundation

/**
 *  @author shuguang, 16-05-08 09:05:16
CATransition 转场动画就是从一个场景以动画的形式过渡到另一个场景。
 */

import UIKit
import XCPlayground

class CATransitionViewController: UIViewController {
    //
    var imageView:UIImageView!
    var currentIndex = 0
    let imageCount = 5
    override func viewDidLoad() {
        //
        view.backgroundColor = UIColor.whiteColor()
        //添加图片
        addImageView()
        //添加根View手势
        let leftSwipeGest = UISwipeGestureRecognizer()
        leftSwipeGest.direction = .Left
        leftSwipeGest.addTarget(self, action: "leftSwipe:")
        view.addGestureRecognizer(leftSwipeGest)
        
        let rightSwipeGest = UISwipeGestureRecognizer()
        rightSwipeGest.direction = .Right
        rightSwipeGest.addTarget(self, action: "rightSwipe:")
        view.addGestureRecognizer(rightSwipeGest)
    }
    
    func addImageView() {
        //
        imageView = UIImageView()
        imageView.frame = UIScreen.mainScreen().bounds // or = view.frame
        imageView.layer.bounds = view.frame
        imageView.image = UIImage(named:"\(currentIndex).jpg")
//        imageView.contentMode = .ScaleAspectFit
        view.addSubview(imageView)
    }
    
    func leftSwipe(gesture:UISwipeGestureRecognizer) {
        //基础转场动画
//        transitionAnimation(false)
        
        //UIView封装
        UIViewTransitionAnimation(false)
    }
    
    func rightSwipe(gesture:UISwipeGestureRecognizer) {
        //基础转场动画
//        transitionAnimation(true)
        
        //UIView封装
        UIViewTransitionAnimation(true)
    }
}

//基础转场动画
extension CATransitionViewController{
    
    /**
     转场动画的使用一般分为以下几个步骤：
     
     1.创建转场动画
     
     2.设置转场类型、子类型（可选）及其他属性
     
     3.设置转场后的新视图并添加动画到图层

     */
    //动画
    func transitionAnimation(isNext:Bool){
        //1.创建转场动画对象
        let transition = CATransition()
        //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
        transition.type = "cube"
        //转场方向
        if isNext{
            transition.subtype = kCATransitionFromRight
        }else{
            transition.subtype = kCATransitionFromLeft
        }
        //设置动画时长
        transition.duration = 1
        
        //更换图片
        currentIndex = isNext ? ((currentIndex+1) % imageCount) : ((currentIndex-1+imageCount) % imageCount)
        //imageView.image = UIImage(named:"\(currentIndex).jpg")
        imageView.layer.contents = UIImage(named:"\(currentIndex).jpg")?.CGImage
        
        //添加转场动画
        imageView.layer.addAnimation(transition, forKey: "KCTransitionAnimation")
    }
}
//UIView封装转场动画
//转场动画演示中，其实仅仅有一个视图UIImageView做转场动画，每次转场通过切换UIImageView的内容而已。
//如果有两个完全不同的视图，并且每个视图布局都很复杂，此时要在这两个视图之间进行转场可以使用
//+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0)方法进行两个视图间的转场，需要注意的是默认情况下转出的视图会从父视图移除，转入后重新添加，可以通过UIViewAnimationOptionShowHideTransitionViews参数设置，设置此参数后转出的视图会隐藏（不会移除）转入后再显示。

//注意：转场动画设置参数完全同基本动画参数设置；同直接使用转场动画不同的是使用UIView的装饰方法进行转场动画其动画效果较少，因为这里无法直接使用私有API。
extension CATransitionViewController{

        func UIViewTransitionAnimation(isNext:Bool) {
        //[在 Swift 中实现 NS_OPTIONS](http://www.cocoachina.com/swift/20150817/13079.html)
        var option:UIViewAnimationOptions
        if (isNext) {
            option = [UIViewAnimationOptions.CurveLinear,UIViewAnimationOptions.TransitionFlipFromRight]
        }else{
            option = [UIViewAnimationOptions.CurveLinear ,UIViewAnimationOptions.TransitionFlipFromLeft]
        }
            
        //更换图片
        currentIndex = isNext ? ((currentIndex+1) % imageCount) : ((currentIndex-1+imageCount) % imageCount)
        UIView.transitionWithView(imageView, duration: 1, options: option, animations: { 
            //替换图片
            self.imageView.image = UIImage(named:"\(self.currentIndex).jpg")
            }, completion: nil)
    }
    /** [在 Swift 中实现 NS_OPTIONS](http://www.cocoachina.com/swift/20150817/13079.html)
     Swift中的对选项的支持没有Objective-C中的NS_OPTIONS来得简洁方便。而且在Swift 1.2的时候，我们还是可以使用”&“和”|”操作符的。下面这段代码在Swift 1.2上是OK的：
     UIView.animateWithDuration(0.3, delay: 1.0, options: UIViewAnimationOptions.CurveEaseIn | UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
     // ...
     }, completion: nil)
     但到了Swift 2.0时，OptionSetType已经不再支持”&“和”|”操作了，因此，上面这段代码需要修改成：
     UIView.animateWithDuration(0.3, delay: 1.0, options: [UIViewAnimationOptions.CurveEaseIn, UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
             // ...
     }, completion: nil)
     
     */


}

XCPlaygroundPage.currentPage.liveView = CATransitionViewController()




//: [Next](@next)
