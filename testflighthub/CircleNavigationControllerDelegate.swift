//
//  NavigationControllerDelegate.swift
//  testflighthub
//
//  Created by Yi Qin on 12/18/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

class CircleNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
  @IBOutlet weak var navigationController: UINavigationController?
  
  var interactionController: UIPercentDrivenInteractiveTransition?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
    
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    let transition = CircleTransitionAnimator()
    transition.presenting = operation == .Pop
    
    return transition
  }
  
  
    
}
