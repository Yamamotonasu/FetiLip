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

    weak var fromDelegate: ZoomAnimatorDelegate?

    weak var toDelegate: ZoomAnimatorDelegate?

    // MARK: - init

    override init() {
        animator = TransitionManager()
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

}
