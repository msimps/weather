//
//  CustomNavigationController.swift
//  Weather
//
//  Created by Matthew on 18.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    
    let interactiveTransition = CustomInteractiveTransition()

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(operation)
        if operation == .push {
            print("Push")
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            print("Pop")
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }

}


final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
           
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)
        destination.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)
        
        
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                source.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                destination.view.transform = .identity
        },
            completion: {finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.view.removeFromSuperview()//.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
           }
       )
    }
}

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)
           
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                
                destination.view.transform = .identity
                destination.view.frame = source.view.frame
                source.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        },
            completion: {finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
           }
       )
    }
    
}


class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(
                target: self,
                action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.y / (recognizer.view?.bounds.height ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.33

            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }

    
}
