//
//  PostLipDetailViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * Lip detaild view conttoller.
 */
class PostLipDetailViewController: UIViewController, ViewControllerMethodInjectable, UIGestureRecognizerDelegate {

    // MARK: - init process

    struct Dependency {
        // Write dependency object.
    }

    func inject(with dependency: Dependency) {
        // Write DI process.
    }

    // MARK: - Outlets

    @IBOutlet weak var lipImageView: UIImageView!

    @IBOutlet private weak var backButton: UIButton!

    var image: UIImage?

    var panGesture: UIPanGestureRecognizer?

    // MARK: - Properties

    let transitionController: ZoomTransitionController = ZoomTransitionController()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func composeUI() {
        self.lipImageView.image = self.image

        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGesture?.delegate = self
        if let pan = self.panGesture {
            self.view.addGestureRecognizer(pan)
        }
    }

    private func subscribe() {
        backButton.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }

    @objc private func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.transitionController.isInteractive = true
            self.navigationController?.popViewController(animated: true)
        case .ended:
            if self.transitionController.isInteractive {
                self.transitionController.isInteractive = false
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            if self.transitionController.isInteractive {
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }

}

extension PostLipDetailViewController: ZoomAnimatorDelegate {

    func transitionWillStartWith(zoomAnimator: TransitionManager) {
        self.backButton.alpha = 0
    }

    func transitionDidEndWith(zoomAnimator: TransitionManager) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backButton.alpha = 1.0
        }
    }

    func referenceImageView(for zoomAnimator: TransitionManager) -> UIImageView? {
        return self.lipImageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: TransitionManager) -> CGRect? {
        return self.lipImageView.frame
    }

}

/**
 * PostLipDetailViewController generator.
 */
final class PostLipDetailViewControllerGenerator {

    public init() {}

    public static func generate() -> UIViewController {
        guard let vc = R.storyboard.postLipDetail.postLipDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init())
        return vc
    }

}
