//
//  ExampleAnimatedTransitioning.swift
//  PresentationsDemo
//
//  Created by pengyucheng on 17/11/2016.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

//UIViewControllerAnimatedTransitioning protocol performs the custom animations for transitioning between view controllers.
class ExampleAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning
{
    //used to determine if the presentation animation is presenting (as opposed to dismissing).
    var isPresentation : Bool = false
    
    //returns the duration in seconds of the transition animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }

    //get the respective views of these view controllers. 
    //Next we get the container view and if the presentation animation is presenting, we add the to view to the container view.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        //get the from and to view controllers from the UIViewControllerContextTransitioning object.
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        //determine the start and end positions of the view.
        let fromView = fromVC?.view
        let toView = toVC?.view
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        //decide on which view controller to animate based on whether the transition is a presentation or dismissal
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        var initialFrameForVC = finalFrameForVC
        //This will animate the view from right to left during a presentation and vice versa during dismissal.
        initialFrameForVC.origin.x += initialFrameForVC.size.width
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.allowUserInteraction, animations:{
            
            //we move the view to the final position.
            animatingView?.frame = finalFrame
        
        }, completion:{ (value: Bool) in
            
            if !self.isPresentation {
                //If the transition is a dismissal, we remove the view.
                fromView?.removeFromSuperview()
            }
            //we complete the transition by calling transitionContext.completeTransition()
            transitionContext.completeTransition(true)
        })
    }
}
