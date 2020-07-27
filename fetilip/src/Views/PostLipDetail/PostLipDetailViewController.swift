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

    @IBOutlet private weak var reviewTextView: UITextView!

    @IBOutlet private weak var userImage: UIImageView!

    @IBOutlet private weak var userName: UILabel!

    // MARK: - Properties

    let transitionController: ZoomTransitionController = ZoomTransitionController()

    var field: PostDomainModel?

    var image: UIImage?

    var panGesture: UIPanGestureRecognizer!

    /// Load event
    let firstLoadEvent: PublishSubject<PostDomainModel> = PublishSubject()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        subscribeUI()
        if let model = field {
            firstLoadEvent.onNext(model)
        } else {
            assertionFailure()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Private functions

    private func composeUI() {
        self.lipImageView.image = self.image
        self.reviewTextView.text = self.field?.review

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
        let input = ViewModel.Input(firstLoadEvent: firstLoadEvent.asObservable())
        let output = viewModel.transform(input: input)

        output.userDataObservable.drive(onNext: { [weak self] domain in
            self?.drawUserData(domain)
        }).disposed(by: rx.disposeBag)
    }

    /**
     * Draw user data.
     *
     * - Parameters
     *  - userDomain : UserDomainModel
     */
    private func drawUserData(_ userDomain: UserDomainModel) {
        if userDomain.hasImage {
            FirestorageLoader.loadImage(storagePath: userDomain.imageRef)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] image in
                    self?.userImage.image = image
                }, onError: { [weak self] e in
                    self?.userImage.image = R.image.default_icon_female()
                }).disposed(by: rx.disposeBag)
        } else {
            userImage.image = R.image.default_icon_female()
        }
        userName.text = userDomain.userName
    }

    // MARK: - UIPanGestureRecognizer

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
