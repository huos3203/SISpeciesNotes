//
//  OverlayAnimationController.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/3/30.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

//动画控制器
class OverlayAnimationController: NSObject,UIViewControllerAnimatedTransitioning
{
    
//    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        核心动画
//        获取fromView ,ToView
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else
        {
            return
        }
        
//        containerView
        guard let containerView = transitionContext.containerView()
            else
        {
            return
        }
        
        let fromView = fromVC.view
        let toView = toVC.view
        let duration = self.transitionDuration(transitionContext)
        
        if toVC.isBeingPresented()
        {
            containerView.addSubview(toView)
//            toView 宽高
            let toViewWidth = containerView.frame.width * 2/3,toViewHeight = containerView.frame.height * 2/3
            toView.bounds = CGRect(x: 0, y: 0, width: 1, height: toViewHeight)
            
            if #available(iOS 8, *){
                
                UIView.animateWithDuration(duration, delay: 0, options: .OverrideInheritedDuration, animations: { () -> Void in
                    toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                    }, completion: { _ in
                        let isCancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(isCancelled)
                })
                
            }
        }
        
        if fromVC.isBeingDismissed()
        {
            let fromViewHeight = fromView.frame.height
            UIView.animateWithDuration(duration, delay: 0, options: .OverrideInheritedDuration, animations: { () -> Void in
                fromView.bounds = CGRect(x: 0, y: 0, width: 1, height: fromViewHeight)
                }, completion: {_ in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(isCancelled)
            })
            
        }
        
        
}
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
}
