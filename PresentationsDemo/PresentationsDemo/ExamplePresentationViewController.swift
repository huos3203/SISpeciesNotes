//
//  ExamplePesentationViewController.swift
//  PresentationsDemo
//
//  Created by pengyucheng on 17/11/2016.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
//UIAdaptivePresentationControllerDelegate转场协调器，可在转场 动画发生的同时执行其他动画。
//主要在model转场和交互转场取消时使用。在此处并未用到

//UIPresentationController类主要给 Modal 转场带来了以下几点变化：
//1定制 presentedView 的外观：设定 presentedView 的尺寸以及在 containerView 中添加自定义视图并为这些视图添加动画；
//2可以选择是否移除 presentingView；
//3可以在不需要动画控制器的情况下单独工作；
//4iOS 8 中的适应性布局。


//UIAdaptivePresentationControllerDelegate protocol will allows us to specify the adaptive presentation style to use when presenting this controller.
class ExamplePresentationViewController: UIPresentationController,UIAdaptivePresentationControllerDelegate {

    //登场视图的背景
    var chromeView: UIView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?)
    {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        //登场视图的背景样式
        chromeView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        chromeView.alpha = 0.0
        //退场手势
        let chromeViewTap = UITapGestureRecognizer.init(target: self, action: #selector(ExamplePresentationViewController.chromeViewTapped(_:)))
        chromeView.addGestureRecognizer(chromeViewTap)
    }
    
    //点击执行退场动画
    @objc func chromeViewTapped(_ gesture:UITapGestureRecognizer)
    {
        if gesture.state == .ended
        {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    //重载存储属性：get方法返回登场页面的位置和大小
    override var frameOfPresentedViewInContainerView: CGRect
    {
        var presentViewFrame = CGRect.zero
        let containerBounds = containerView?.bounds
        //登场控制器内容页面的大小
        presentViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerBounds?.size)!)
        presentViewFrame.origin.x = (containerBounds?.size.width)! - presentViewFrame.size.width
        return presentViewFrame
    }
    
    //返回登场控制器内容页面的大小，在这里设置为屏幕宽度的三分之一款
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize.init(width:CGFloat(floorf(Float(parentSize.width/3.0))), height: parentSize.height)
    }
    
    /*
     转场开始时
     animate(alongsideTransition:completion:)：转场协调器确保了转场与过渡动画同步进行
        1. 添加过渡视图：在containerView中插入视图chromeView
        2. 添加转场动画:为转场中涉及到的视图（chromeView）
    */
    override func presentationTransitionWillBegin() {
        //
        chromeView.frame = (self.containerView?.bounds)!
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at:0)
        //coordinator转场协调器负责转场动画的呈现和dismissal
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            //添加登场动画
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                //animate the alpha to 1.0.
                self.chromeView.alpha = 1.0
            }, completion:nil)
            
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    
    /*
     转场结束时
        1. 添加消失时转场动画
     */
    override func dismissalTransitionWillBegin()
    {
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            //添加退场动画
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.chromeView.alpha = 0.0
            }, completion:nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    //在设备旋转的情况下，重置背景视图的外观和登场控制器内容的外观
    override func containerViewWillLayoutSubviews()
    {
        chromeView.frame = (containerView?.bounds)!
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    //设置整个转场动画是否将覆盖全屏幕
    override var shouldPresentInFullscreen: Bool
    {
        return true
    }
    
    /*
        两种覆盖全屏的方式：
        1. .OverFullScreen: 浮动式全屏，即：登场视图下方的视图不会完全被遮挡
        2. .FullScreen  : 全覆盖全屏 即：占据全屏来显示登场视图
     */
    
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
