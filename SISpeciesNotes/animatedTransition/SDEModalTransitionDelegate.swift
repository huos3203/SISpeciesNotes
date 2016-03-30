//
//  SDEModalTransitionDelegate.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/3/30.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

class SDEModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate
{
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimationController()
    }
    
    @available(iOS 8.0,*)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
//        code
        return nil
    }

}
