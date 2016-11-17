//
//  ExampleTransitioningDelegate.swift
//  PresentationsDemo
//
//  Created by pengyucheng on 17/11/2016.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
//UIViewControllerTransitioningDelegate转场代理：UIViewController的transitioningDelegate属性遵守该协议
class ExampleTransitioningDelegate: NSObject,UIViewControllerTransitioningDelegate
{
    //returns a presentation controller that manages the presentation of a view controller.
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let presentationController = ExamplePresentationViewController(presentedViewController:presented, presenting:presenting)
        
        return presentationController
    }
    
    //returns an animator object that will be used when a view controller is being presented
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = ExampleAnimatedTransitioning()
        animationController.isPresentation = true
        return animationController
    }
    
    //returns the animation controller to be used in dismissing the view controller.
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = ExampleAnimatedTransitioning()
        animationController.isPresentation = false
        return animationController
    }
}
