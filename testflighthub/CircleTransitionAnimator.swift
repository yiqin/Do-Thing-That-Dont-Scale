//
//  CircleTransitionAnimator.swift
//  testflighthub
//
//  Created by Yi Qin on 12/18/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    var presenting = false

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.00;    // 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext

        var containerView = transitionContext.containerView()
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!

        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        var extremePoint : CGPoint
        var radius : CGFloat
        if !presenting {
            button.frame = CGRectMake(screenWidth*0.5-5, screenHeight-5, 10, 10)
            extremePoint = CGPoint(x: button.center.x - 0, y: CGRectGetHeight(toViewController.view.bounds))
            radius = 5*sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        }
        else {
            button.frame = CGRectMake(screenWidth*0.5-5, DeviceManager.sharedInstance.trendingScrollYPosition+5, 10, 10)
            extremePoint = CGPoint(x: button.center.x - 0, y: CGRectGetHeight(toViewController.view.bounds))
            radius = 5*sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        }
        
        var circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
        var circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        
        containerView.addSubview(toViewController.view)

        var maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer

        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
    }

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
        self.transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        
        // Additional.......
        self.transitionContext?.viewControllerForKey(UITransitionContextToViewKey)?.view.layer.mask = nil
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewKey)?.view.layer.mask = nil
        
        
    }
  
}
