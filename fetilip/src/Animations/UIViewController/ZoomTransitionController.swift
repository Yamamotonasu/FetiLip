//
//  ZoomTransitionController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/05.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

// Reference: https://github.com/masamichiueta/FluidPhoto/tree/master/FluidPhoto/Animation

class ZoomTransitionController: NSObject {

    // MARK: - Properties

    let animator: TransitionManager

    let interactionController: ZoomDismissalInteractionController

    var isInteractive: Bool = false

    weak var fromDelegate: ZoomAnimatorDelegate?

    weak var toDelegate: ZoomAnimatorDelegate?

    // MARK: - init

    override init() {
        animator = TransitionManager()
        interactionController = ZoomDismissalInteractionController()
        super.init()
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension ZoomTransitionController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresent = true
        self.animator.fromDelegate = fromDelegate
        self.animator.toDelegate = toDelegate
        return self.animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresent = false
        let tmp = self.fromDelegate
        self.animator.fromDelegate = self.toDelegate
        self.animator.toDelegate = tmp
        return self.animator
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !self.isInteractive {
            return nil
        }
        self.interactionController.animator = animator
        return self.interactionController
    }

}

// MARK: - ZoomDismissalInteractionController

extension ZoomTransitionController {

    /// didPanWith wrapper function in ZoomDismissalInteractionController.
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        self.interactionController.didPanWith(gestureRecognizer: gestureRecognizer)
    }

}

// MARK: - UINavigationControllerDelegate

extension ZoomTransitionController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.animator.isPresent = true
            self.animator.fromDelegate = fromDelegate
            self.animator.toDelegate = toDelegate
        } else {
            self.animator.isPresent = false
            let tmp = self.fromDelegate
            self.animator.fromDelegate = self.toDelegate
            self.animator.toDelegate = tmp
        }

        return self.animator
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !self.isInteractive {
            return nil
        }

        self.interactionController.animator = animator
        return self.interactionController
    }

}
