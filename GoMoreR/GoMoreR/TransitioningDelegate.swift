//
//  TransitioningDelegate.swift
//  GoMoreR
//
//  Created by JakeChang on 2019/5/10.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return AnimatedTransitioning(transitionType: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatedTransitioning(transitionType: .dismissing)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        var frame = inView.bounds
        
        switch transitionType {
        case .presenting:
            frame.origin.y = frame.size.height
            toView.frame = frame
            
            inView.addSubview(toView)
            
            /*
             UIView.animate(withDuration: transitionDuration(using: transitionContext),
             delay: 0,
             usingSpringWithDamping: 0.8,
             initialSpringVelocity: 3,
             options: .curveEaseIn,
             animations: {
             
             }, completion: { finised in
             
             })
             */
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = CGRect(x: fromView.frame.minY, y: -frame.size.height, width: fromView.frame.width, height: fromView.frame.height)
                toView.frame = inView.bounds
                
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            })
            
        case .dismissing:
            toView.frame = CGRect(x: toView.frame.minX, y: -frame.size.height, width: toView.frame.width, height: toView.frame.height)
            inView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = CGRect(x: fromView.frame.minX, y: frame.size.height, width: fromView.frame.width, height: fromView.frame.height)
                toView.frame = CGRect(x: toView.frame.minX, y: frame.minY, width: toView.frame.width, height: toView.frame.height)

            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            })
        }
    }
    
}

class PresentationController: UIPresentationController {
    
    override var shouldRemovePresentersView: Bool {
        return true
    }
    
}

