//
//  ExamplePesentationViewController.swift
//  PresentationsDemo
//
//  Created by pengyucheng on 17/11/2016.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
//UIAdaptivePresentationControllerDelegate转场协调器，可在转场 动画发生的同时执行其他动画。主要在model转场和交互转场取消时使用。在此处并未用到

//UIPresentationController类主要给 Modal 转场带来了以下几点变化：
//定制 presentedView 的外观：设定 presentedView 的尺寸以及在 containerView 中添加自定义视图并为这些视图添加动画；
//可以选择是否移除 presentingView；
//可以在不需要动画控制器的情况下单独工作；
//iOS 8 中的适应性布局。


//UIAdaptivePresentationControllerDelegate protocol will allows us to specify the adaptive presentation style to use when presenting this controller.
class ExamplePresentationViewController: UIPresentationController,UIAdaptivePresentationControllerDelegate {

    var chromeView: UIView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?)
    {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        //We create a dark view – chromeView – and set its alpha to 0 so it won’t be initially visible.
        chromeView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        chromeView.alpha = 0.0
        //手势
        let chromeViewTap = UITapGestureRecognizer.init(target: self, action: #selector(ExamplePresentationViewController.chromeViewTapped(_:)))
        chromeView.addGestureRecognizer(chromeViewTap)
    }
    
    // We then add a gesture recognizer to the chromeView that will dismiss the presented view controller when the chrome is tapped.
    @objc func chromeViewTapped(_ gesture:UITapGestureRecognizer)
    {
        print("------点击chromeView ---------")
        //
        if gesture.state == .ended
        {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    //creates the frame rectangle that will be assigned to the presented view.
    override var frameOfPresentedViewInContainerView: CGRect
    {
        var presentViewFrame = CGRect.zero
        let containerBounds = containerView?.bounds
        presentViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerBounds?.size)!)
        presentViewFrame.origin.x = (containerBounds?.size.width)! - presentViewFrame.size.width
        return presentViewFrame
    }
    
    //sizeForChildContentContainer() returns the size of the specified child view controller’s content. Here we set it to be a third of the screen.
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        //
        return CGSize.init(width:CGFloat(floorf(Float(parentSize.width/3.0))), height: parentSize.height)
    }
    
    //We override presentationTransitionWillBegin() above in which we set the chrome’s frame and add it to the container view.
    override func presentationTransitionWillBegin() {
        //
        chromeView.frame = (self.containerView?.bounds)!
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at:0)
        //We then check the value of the presented view controller’s transition coordinator. 
        //The transition coordinator is responsible for animating the presentation and dismissal of the content.
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            //与动画控制器中的转场动画同步，执行其他动画
            //animateAlongsideTransition() to specify additional animations to be used alongside the presentation animation.
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                //animate the alpha to 1.0.
                self.chromeView.alpha = 1.0
            }, completion:nil)
            
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    
    //we do the opposite of what we did in presentationTransitionWillBegin()
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            //与动画控制器中的转场动画同步，执行其他动画
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                //animate the alpha of the chrome back to 0.
                self.chromeView.alpha = 0.0
            }, completion:nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    //This sets the frames of the chrome and presented views to the bounds of the container view. If this isn’t done then they won’t resize if the device is rotated.
    override func containerViewWillLayoutSubviews() {
        chromeView.frame = (containerView?.bounds)!
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    //This determines whether the presentation will cover the full screen.
    override var shouldPresentInFullscreen: Bool{
        return true
    }

    //indicates that the presented view should cover the full screen. We can either return .OverFullScreen or .FullScreen. The difference between the two is that with .OverFullScreen if the presented view controller’s view doesn’t cover the underlying content, then the views under the presented view controller will be visible.
    override var adaptivePresentationStyle: UIModalPresentationStyle
    {
        return UIModalPresentationStyle.fullScreen
    }
    
    //提供给动画控制器使用的视图，默认返回 presentedVC.view，通过重写该方法返回其他视图，但一定要是 presentedVC.view 的上层视图。
//    override var presentedView:UIView
//    {
//        return nil
//    }
}
