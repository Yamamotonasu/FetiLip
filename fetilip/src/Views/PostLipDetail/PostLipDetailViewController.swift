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

    // MARK: - ViewModel

    typealias ViewModel = PostLipDetailViewModel

    private lazy var viewModel: ViewModel = PostLipDetailViewModel(userModel: UsersModelClient())

    // MARK: - init process

    struct Dependency {
        let displayImage: UIImage?
        let postModel: PostDomainModel
    }

    func inject(with dependency: Dependency) {
        image = dependency.displayImage
        field = dependency.postModel
    }

    // MARK: - Outlets

    @IBOutlet weak var lipImageView: UIImageView!

    @IBOutlet private weak var backButton: UIButton!

    @IBOutlet private weak var reviewLabel: UILabel!


    // MARK: - Properties

    let transitionController: ZoomTransitionController = ZoomTransitionController()

    var field: PostDomainModel?

    var image: UIImage?

    var panGesture: UIPanGestureRecognizer!

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        subscribeUI()
        viewModel.fetchUserData(documentReference: field!.userRef)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func composeUI() {
        self.lipImageView.image = self.image
        self.reviewLabel.text = self.field?.review

        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }

    private func subscribe() {
        backButton.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input()
        let output = viewModel.transform(input: input)


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

    // MARK: - UIPanGestureRecognizer

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = panGesture {
            let velocity = gestureRecognizer.velocity(in: self.view)
            var velocityCheck = false
            if UIDevice.current.orientation.isLandscape {
                velocityCheck = velocity.x < 0
            } else {
                velocityCheck = velocity.y < 0
            }
            if velocityCheck {
                return false
            }
        }
        return true
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

    public static func generate(displayImage: UIImage, postField: PostDomainModel) -> UIViewController {
        guard let vc = R.storyboard.postLipDetail.postLipDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(displayImage: displayImage, postModel: postField))
        return vc
    }

}
