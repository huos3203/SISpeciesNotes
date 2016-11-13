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
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        核心动画
//        获取fromView ,ToView
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else
        {
            return
        }
        
//        containerView
        guard let containerView:UIView? = transitionContext.containerView
            else
        {
            return
        }
        
        let fromView = fromVC.view
        let toView = toVC.view
        let duration = self.transitionDuration(using: transitionContext)
        
        if toVC.isBeingPresented
        {
            containerView?.addSubview(toView!)
//            toView 宽高
            let toViewWidth = (containerView?.frame.width)! * 2/3,toViewHeight = (containerView?.frame.height)! * 2/3
            toView?.bounds = CGRect(x: 0, y: 0, width: 1, height: toViewHeight)
            
            if #available(iOS 8, *){
                
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                    toView?.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                    }, completion: { _ in
                        let isCancelled = transitionContext.transitionWasCancelled
                        transitionContext.completeTransition(!isCancelled)
                })
                
            }
        }
        
        if fromVC.isBeingDismissed
        {
            let fromViewHeight = fromView?.frame.height
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                fromView?.bounds = CGRect(x: 0, y: 0, width: 1, height: fromViewHeight!)
                }, completion: {_ in
                    let isCancelled = transitionContext.transitionWasCancelled
                    transitionContext.completeTransition(!isCancelled)
            })
            
        }
        
        
}
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
}
