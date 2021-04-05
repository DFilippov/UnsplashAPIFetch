//
//  VCAnimatedTransitioning.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 23/01/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class VCAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.3
    let isPresented: Bool
    
    let startImageView: UIView
    
    init(isPresented: Bool, view: UIView) {
        self.isPresented = isPresented
        self.startImageView = view

    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            presentTransition(using: transitionContext)
        } else {
            dismissTransition(using: transitionContext)
        }
    }
    
    func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let detailVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let toView = transitionContext.view(forKey: .to)!
        
        let startFrame = startImageView.frame
        let finalFrame = transitionContext.finalFrame(for: detailVC)

        let scaleFactor = CGAffineTransform(scaleX: 0.2, y: 0.2)

//        toView.frame.origin = startFrame.origin
        toView.center = startImageView.center
//        toView.center = CGPoint(x: startFrame.midX, y: startFrame.midY)
        toView.alpha = 0.6
        toView.transform = scaleFactor
        toView.layer.cornerRadius = toView.frame.height / 2.5
        toView.clipsToBounds = true
        
        containerView.addSubview(toView)
        containerView.insertSubview(startImageView, aboveSubview: toView)

        print(#line, #function, self, "\n\nstartFrame", startFrame, "\n\nfinalFrame", finalFrame, "startImageView.center", startImageView.center)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            //            usingSpringWithDamping: <#T##CGFloat#>,
            //            initialSpringVelocity: <#T##CGFloat#>,
            options: [.curveEaseOut],
            animations: {
                //                toView.center = CGPoint(x: finalFrame.midX,y: finalFrame.midY)
                toView.transform = .identity
                toView.frame = finalFrame
                toView.alpha = 1.0
                self.startImageView.alpha = 0.0
                self.startImageView.layer.cornerRadius = 0.0
                self.startImageView.layer.masksToBounds = false
            }) { (finished) in
            transitionContext.completeTransition(finished)
        }
        
//        let option = UIView.AnimationOptions(rawValue: UIView.AnimationOptions.curveEaseOut.rawValue)
//        let keyframeAnimationOption = UIView.KeyframeAnimationOptions.init(rawValue: option.rawValue)
//        UIView.animateKeyframes(
//            withDuration: duration,
//            delay: 0.0,
//            options: [keyframeAnimationOption],
//            animations:  {
//
//                UIView.addKeyframe(
//                    withRelativeStartTime: 0.0,
//                    relativeDuration: 1,
//                    animations: {
//                        let scale: CGFloat = 1.2
//                        self.startImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
//                    })
//
//                let startTime = 1.0
//                let relativeDuration = self.duration - startTime
//
//                UIView.addKeyframe(
//                    withRelativeStartTime: startTime,
//                    relativeDuration: 1.0,
//                    animations: {
//                        toView.transform = .identity
//                        toView.frame = finalFrame
//                        toView.alpha = 1.0
//                        self.startImageView.alpha = 0.0
//                    })
//
//            },
//            completion: { finished in
//                transitionContext.completeTransition(finished)
//
//        })

//        // first animate selected image in table - scale it a bit
//        let firstPartDuration = 0.15
//        UIView.animate(
//            withDuration: firstPartDuration,
//            delay: 0.0,
//            options: [.curveEaseIn],
//            animations: {
//                let scale: CGFloat = 1.3
////                self.startImageView.transform = CGAffineTransform(translationX: 15, y: 0)
//                self.startImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
//                self.startImageView.center  = toView.center
//                self.startImageView.alpha = 0.7
//            }
//        )
//
//        // then animate the second part of appearing DetailVC
//        UIView.animate(
//            withDuration: duration,
//            delay: firstPartDuration - 0.05,
////            delay: 0.0,
//            //            usingSpringWithDamping: <#T##CGFloat#>,
//            //            initialSpringVelocity: <#T##CGFloat#>,
//            options: [.curveEaseOut],
//            animations: {
//                //                toView.center = CGPoint(x: finalFrame.midX,y: finalFrame.midY)
//                toView.transform = .identity
//                toView.frame = finalFrame
//                toView.alpha = 1.0
//                self.startImageView.alpha = 0.0
//                self.startImageView.layer.cornerRadius = 0.0
//                self.startImageView.layer.masksToBounds = false
//        }) { (finished) in
//            transitionContext.completeTransition(finished)
//        }
    }
    
    func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView =  transitionContext.containerView
        
//        guard let fromView = transitionContext.view(forKey: .from) else {
//            transitionContext.completeTransition(false)
//            print("COULDN'T GET view for key .from")
//            return
//        }
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            print("COULDN'T GET viewController for key .from")
            return
        }
        
        let toVC = transitionContext.viewController(forKey: .to)!
        
//        let toView = toVC.view!
        
        let startFrame = fromVC.view.frame
        let fromView = fromVC.view!
//        let startFrame = fromView.frame
        
        containerView.addSubview(startImageView)
        containerView.addSubview(fromView)
        
//        let finalFrame = transitionContext.finalFrame(for: toVC)
//        let finalFrame = startImageView.superview!.convert(startImageView.frame, to: nil)
        
//
//        guard let toView = transitionContext.viewController(forKey: .from) else {
//            transitionContext.completeTransition(false)
//            print("COULDN'T GET view for key .to")
//            return
//        }


//        let finalFrame = transitionContext.initialFrame(for: )
        
//        let finalFrame = fromView.convert(fromView.frame, to: nil)
//        let finalFrame = startImageView.convert(startImageView.frame, to: nil)
        let finalFrame = startImageView.frame
        
        //        print("FRame of startImageView", startImageView.frame, "\nBOUNDS of startImageView", startImageView.bounds)
        //        print("FINAL FRAME dismiTransition", finalFrame)
        //        print("startImageView.superviews", startImageView.superview!)
        
        let xScale = finalFrame.width / startFrame.width
        let yScale = finalFrame.height / startFrame.height
        let scaleFactor = CGAffineTransform(scaleX: xScale, y: yScale)
        
        
        
        print(#line, #function, self, "\n\nstartFrame", startFrame, "\n\nfinalFrame", finalFrame, "\n\nfromVC", fromVC, "\n\n", containerView, "\n toVC", toVC.view.frame)
        
//        UIView.animate(
//            withDuration: duration,
//            delay: 0.0,
////            usingSpringWithDamping: <#T##CGFloat#>,
////            initialSpringVelocity: <#T##CGFloat#>,
//            options: [.curveEaseOut],
//            animations: {
//                fromView.layer.cornerRadius = 30
//                fromView.clipsToBounds = true
//                fromView.transform = scaleFactor
//                fromView.alpha = 0.5
////                fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
//                fromView.center = self.startImageView.center
////                print("CGPoint(x: finalFrame.midX, y: finalFrame.midY)", fromView.center)
////                fromView.frame = self.startImageView.frame
//                fromView.frame = finalFrame
//                self.startImageView.alpha = 1.0
//        }) { (finished) in
//            transitionContext.completeTransition(finished)
//        }
        
        
        UIView.animateKeyframes(
            withDuration: duration + 0.2,
            delay: 0.0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    fromView.layer.cornerRadius = 30
                    fromView.clipsToBounds = true
                    fromView.transform = scaleFactor
//                    fromView.transform = .identity
                    fromView.center = self.startImageView.center
                    fromView.frame = finalFrame
                    self.startImageView.alpha = 1.0
                    self.startImageView.transform = .identity
                }
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.1) {
                    fromView.alpha = 0.0
//                    self.startImageView.alpha = 1.0
                }
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}
