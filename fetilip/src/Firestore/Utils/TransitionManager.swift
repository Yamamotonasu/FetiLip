//
//  TransitionManager.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/01.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class TransitionManager: NSObject {

    // TODO: Protocol.
    typealias TransitionSource = PostListViewController

    typealias TransitionDestinate = PostLipDetailViewController

    // MARK: - init

    private override init() {}

    // MARK: - Properties

    static let shareInstance: TransitionManager = TransitionManager()

    private var isPresent = false

}

// MARK: - UIViewControllerAnimatedTransitioning

extension TransitionManager: UIViewControllerAnimatedTransitioning {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }

}

// MARK: - Private functions

extension TransitionManager {

    /// Transitioning process.
    private func presenting(transitionContext: UIViewControllerContextTransitioning) {
        let firstViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TransitionSource
        let secondViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! TransitionDestinate
        let containerView = transitionContext.containerView

        // TODO: Fix
        let cell: PostLipCollectionViewCell = firstViewController.lipCollectionView?.cellForItem(at: (firstViewController.lipCollectionView?.indexPathsForSelectedItems?.first)!) as! PostLipCollectionViewCell

        let animationView = UIImageView(image: cell.lipImage.image)

        cell.lipImage.isHidden = true

        secondViewController.view.frame  = transitionContext.finalFrame(for: secondViewController)
        secondViewController.view.alpha = 0
        secondViewController.lipImageView.isHidden = true

        containerView.addSubview(secondViewController.view)
        containerView.addSubview(animationView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations:  {
                   secondViewController.view.alpha = 1.0
                   animationView.frame = containerView.convert(secondViewController.lipImageView.frame, from: secondViewController.view)
        }) { completion in
            secondViewController.lipImageView.isHidden = false
            cell.lipImage.isHidden = false
            animationView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }

    /// Dismissing process.
    private func dismissing(transitionContext: UIViewControllerContextTransitioning) {
        let firstViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TransitionSource
        let secondViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! TransitionDestinate
        let containerView = transitionContext.containerView

        let animationView = secondViewController.lipImageView.snapshotView(afterScreenUpdates: false)
        animationView?.frame = containerView.convert(secondViewController.lipImageView.frame, to: secondViewController.lipImageView.superview)
        secondViewController.lipImageView.isHidden = true

        // TODO: Fix
        let cell: PostLipCollectionViewCell = firstViewController.lipCollectionView?.cellForItem(at: (firstViewController.lipCollectionView?.indexPathsForSelectedItems?.first)!) as! PostLipCollectionViewCell

        cell.lipImage.isHidden = true

        firstViewController.view.frame = transitionContext.finalFrame(for: firstViewController)

        containerView.insertSubview(firstViewController.view, belowSubview: secondViewController.view)
        containerView.addSubview(animationView!)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            secondViewController.view.alpha = 0
            animationView?.frame = containerView.convert(cell.lipImage.frame, from: cell.lipImage.superview)
        }, completion: { completion in
            animationView?.removeFromSuperview()
            secondViewController.lipImageView.isHidden = false
            cell.lipImage.isHidden = false
            transitionContext.completeTransition(true)
        })
    }
}

extension TransitionManager: UIViewControllerTransitioningDelegate {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presenting(transitionContext: transitionContext)
        } else {
            dismissing(transitionContext: transitionContext)
        }
    }

}
