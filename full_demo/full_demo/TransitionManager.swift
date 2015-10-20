//
//  TransitionManager.swift
//  Through Time
//
//  Created by Gregory Johnson on 3/1/15.
//  Copyright (c) 2015 Gregory Johnson. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate
{
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    enum Direction
    {
        case up
        case down
        case right
        case left
    }
    var dir:Direction
    
    init(direction:Direction)
    {
        self.dir = direction;
    }
    
    func changeDir(direction:Direction)
    {
        self.dir = direction
    }
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // set up from 2D transforms that we'll use in the animation
        var offFromY:CGFloat = 0 //starting position for new view Y
        var offToY:CGFloat = 0 //ending position for current view Y
        var offFromX:CGFloat = 0
        var offToX:CGFloat = 0
        if(dir == Direction.right)
        {
            offFromX = -container!.frame.width
            offToX = container!.frame.width
        }
        else if(dir == Direction.left)
        {
            offFromX = container!.frame.width
            offToX = -container!.frame.width
        }
        else if(dir == Direction.up)
        {
            offFromY = container!.frame.height
            offToY = -container!.frame.height
        }
        else if(dir == Direction.down)
        {
            offFromY = -container!.frame.height
            offToY = container!.frame.height
        }
        let offScreenFrom = CGAffineTransformMakeTranslation(offFromX, offFromY)
        let offScreenTo = CGAffineTransformMakeTranslation(offToX, offToY)
        
        // start the toView to the right of the screen
        toView.transform = offScreenFrom
        
        // add the both views to our view controller
        container!.addSubview(toView)
        container!.addSubview(fromView)
        
        // get the duration of the animation
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [], animations:
            {
            
            fromView.transform = offScreenTo
            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
        })
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

