//
//  ZoomDismissalInteractionController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/05.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

/**
 * Handle animation interactive.
 */
class ZoomDismissalInteractionController: NSObject {

    var transitionContext: UIViewControllerContextTransitioning?

    var animator: UIViewControllerAnimatedTransitioning?

    var fromReferenceImageViewFrame: CGRect?

    var toReferenceImageViewFrame: CGRect?

    /// Called every time PanGesture si executed
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        guard let transitionContext = self.transitionContext,
            let animator = animator as? TransitionManager,
            let transitionImageView = animator.transitioningImageView,
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromReferenceImageView = animator.fromDelegate?.referenceImageView(for: animator),
            let toReferenceImageView = animator.toDelegate?.referenceImageView(for: animator),
            let fromReferenceImageViewFrame = self.fromReferenceImageViewFrame,
            let toReferenceImageViewFrame = self.toReferenceImageViewFrame,
            let tab = toVC.tabBarController as? GlobalTabBarController else {
                return
        }

        fromReferenceImageView.isHidden = true

        let anchorPoint = CGPoint(x: fromReferenceImageViewFrame.midX, y: fromReferenceImageViewFrame.midY)
        let translatedPoint = gestureRecognizer.translation(in: fromReferenceImageView)
        let verticalDelta: CGFloat = translatedPoint.y < 0 ? 0 : translatedPoint.y

        let backgroundAlpha = backgroundAlphaFor(view: fromVC.view, withPanningVerticalDelta: verticalDelta)
        let scale = scaleFor(view: fromVC.view, withPanningVerticalDelta: verticalDelta)

        fromVC.view.alpha = backgroundAlpha

        transitionImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        let newCenter = CGPoint(x: anchorPoint.x + translatedPoint.x, y: anchorPoint.y + translatedPoint.y - transitionImageView.frame.height * (1 - scale) / 1.5)
        transitionImageView.center = newCenter

        toReferenceImageView.isHidden = true

        transitionContext.updateInteractiveTransition(1 - scale)

        if gestureRecognizer.state == .ended {
            let velocity = gestureRecognizer.velocity(in: fromVC.view)
            if velocity.y < 0 || newCenter.y < anchorPoint.y {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 0,
                               options: [],
                               animations: {
                                transitionImageView.frame = fromReferenceImageViewFrame
                                fromVC.view.alpha = 1.0
                                tab.customTabBar.isHidden = true

                }, completion: { _ in
                    toReferenceImageView.isHidden = false
                    fromReferenceImageView.isHidden = false
                    transitionImageView.removeFromSuperview()
                    animator.transitioningImageView = nil
                    transitionContext.cancelInteractiveTransition()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    animator.toDelegate?.transitionDidEndWith(zoomAnimator: animator)
                    animator.fromDelegate?.transitionDidEndWith(zoomAnimator: animator)
                    self.transitionContext = nil
                })
                return
            }

            let finalTransitionSize = toReferenceImageViewFrame

            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [],
                           animations: {
                            fromVC.view.alpha = 0
                            transitionImageView.frame = finalTransitionSize
                            tab.customTabBar.isHidden = false
                }, completion: { _ in
                    transitionImageView.removeFromSuperview()
                    toReferenceImageView.isHidden = false
                    fromReferenceImageView.isHidden = false

                    self.transitionContext?.finishInteractiveTransition()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    animator.toDelegate?.transitionDidEndWith(zoomAnimator: animator)
                    animator.fromDelegate?.transitionDidEndWith(zoomAnimator: animator)
                    self.transitionContext = nil
            })
        }
    }

    /// Return the alpha value according to the amount of pulling the screen.
    private func backgroundAlphaFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingAlpha: CGFloat = 1.0
        let finishingAlpha: CGFloat = 0.0
        let totalAvailableAlpha: CGFloat = startingAlpha - finishingAlpha

        let maximumDelta = view.bounds.height / 4.0
        let deltaAsPercentageMaximum = min(abs(verticalDelta) / maximumDelta, 1.0)

        return startingAlpha - (deltaAsPercentageMaximum * totalAvailableAlpha)
    }

    /// Return the scalling value according to the amout of pulling the screen.
    private func scaleFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingScale: CGFloat = 1.0
        let finalScale: CGFloat = 0.5
        let totalAvailableScale = startingScale - finalScale

        let maximumDelta = view.bounds.height / 2.0
        let deltaAsPercentageMaximum = min(abs(verticalDelta) / maximumDelta, 1.0)

        return startingScale - (deltaAsPercentageMaximum * totalAvailableScale)
    }

}

// MARK: - UIViewControllerInteractiveTransitioning

extension ZoomDismissalInteractionController: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        let containerView = transitionContext.containerView

        guard let animator = self.animator as? TransitionManager,
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromReferenceImageViewFrame = animator.fromDelegate?.referenceImageViewFrameInTransitioningView(for: animator),
            let toReferenceImageViewFrame = animator.toDelegate?.referenceImageViewFrameInTransitioningView(for: animator),
            let fromReferenceImageView = animator.fromDelegate?.referenceImageView(for: animator) else {
            return
        }

        animator.fromDelegate?.transitionWillStartWith(zoomAnimator: animator)
        animator.toDelegate?.transitionWillStartWith(zoomAnimator: animator)

        self.fromReferenceImageViewFrame = fromReferenceImageViewFrame
        self.toReferenceImageViewFrame = toReferenceImageViewFrame

        let referenceImage = fromReferenceImageView.image!

        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

        if animator.transitioningImageView == nil {
            let transitionImageView = UIImageView(image: referenceImage)
            transitionImageView.contentMode = .scaleAspectFill
            transitionImageView.clipsToBounds = true
            transitionImageView.cornerRadius = 10
            transitionImageView.borderWidth = 0.5
            transitionImageView.borderColor = .lightGray
            transitionImageView.frame = fromReferenceImageViewFrame
            animator.transitioningImageView = transitionImageView
            containerView.addSubview(transitionImageView)
        }
    }
}
