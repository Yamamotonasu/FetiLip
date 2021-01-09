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

    private lazy var viewModel: ViewModel = PostLipDetailViewModel(userModel: UsersModelClient(), postModel: PostModelClient(), violationModel: ViolationReportClient())

    // MARK: - init process

    struct Dependency {
        let displayImage: UIImage?
        let postModel: PostDomainModel
        let fromMyPostList: Bool
    }

    func inject(with dependency: Dependency) {
        image = dependency.displayImage
        field = dependency.postModel
        fromMyPostList = dependency.fromMyPostList
    }

    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet private weak var contentView: UIView!

    @IBOutlet weak var lipImageView: UIImageView!

    @IBOutlet private weak var backButton: UIButton!

    @IBOutlet private weak var reviewTextView: UITextView!

    @IBOutlet private weak var userImage: UIImageView!

    @IBOutlet private weak var userName: UILabel!

    @IBOutlet private weak var bottomView: UIView!

    @IBOutlet private weak var editButton: UIButton!

    @IBOutlet private weak var deleteButton: UIButton!

    @IBOutlet private weak var menuButton: UIButton!

    // MARK: - Properties

    let transitionController: ZoomTransitionController = ZoomTransitionController()

    var field: PostDomainModel!

    var image: UIImage?

    var fromMyPostList: Bool!

    var panGesture: UIPanGestureRecognizer!

    var displayUserDomainModel: UserDomainModel?

    /// Load event
    let firstLoadEvent: PublishSubject<PostDomainModel> = PublishSubject()

    private let deleteEvent: PublishSubject<PostDomainModel> = PublishSubject()

    private let violationReportEvent: PublishSubject<PostDomainModel> = PublishSubject()

    private var isMyPost: Bool {
        return LoginAccountData.uid! == field.userUid
    }

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        subscribeUI()
        firstLoadEvent.onNext(field)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Private functions

    private func composeUI() {
        self.lipImageView.image = self.image
        self.reviewTextView.text = self.field?.review
        self.bottomView.isHidden = !self.isMyPost
        self.editButton.isHidden = true
        self.menuButton.isHidden = self.isMyPost

        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
    }

    private func subscribe() {
        let tapGesture = UITapGestureRecognizer()
        userImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.transitionUserDetail()
        }).disposed(by: rx.disposeBag)

        backButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)

        deleteButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.displayDeleteAlert()
        }).disposed(by: rx.disposeBag)

        menuButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.displayMenu()
        }).disposed(by: rx.disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(firstLoadEvent: firstLoadEvent.asObservable(),
                                    deleteEvent: deleteEvent,
                                    violationReportEvent: violationReportEvent)
        let output = viewModel.transform(input: input)

        output.userDataObservable.retryWithRetryAlert { [weak self] _ in
            self?.firstLoadEvent.onNext(field)
        }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] domain in
                self?.displayUserDomainModel = domain
                self?.drawUserData(domain)
            }).disposed(by: rx.disposeBag)

        output.deleteResult.retryWithRetryAlert { [weak self] _ in
            guard let _self = self else { return }
            _self.deleteEvent.onNext(_self.field)
        }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                // Delete post deleted.
                let refreshLoadType: RefreshLoadType = self?.fromMyPostList == true ? .refreshMyPost : .refresh
                PostListViewController.refreshSubject.onNext(refreshLoadType)
                AppAlert.show(message: R._string.success.delete, alertType: .success)
            }, onError: { e in
                log.error(e.localizedDescription)
                AppAlert.show(message: R._string.error.delete, alertType: .error)
            }).disposed(by: rx.disposeBag)

        output.sendViolationReportResult.retryWithRetryAlert { [weak self] _ in
            guard let _self = self else { return }
            _self.violationReportEvent.onNext(_self.field)
        }.subscribe(onNext: { _ in
            AppAlert.show(message: R._string.success.violationReports, alertType: .success)
        }, onError: { e in
            log.error(e.localizedDescription)
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
                    self?.displayUserDomainModel?.setUserImage(with: image)
                }, onError: { [weak self] _ in
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

    /**
     * Transition to other user profile.
     */
    private func transitionUserDetail() {
        guard let userDomainModel = displayUserDomainModel else { return }

        let viewController = UserDetailViewControllerGenerator.generate(userDomainModel: userDomainModel, uid: field.userRef.documentID)
        self.present(viewController, animated: true)
    }

    private func displayDeleteAlert() {
        let actionSheet = UIAlertController(title: R._string.success.reallyWantToDelete, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: R._string.view_message.deletePost, style: .default, handler: { [unowned self] _ in
            self.deleteEvent.onNext(self.field)
        }))
        actionSheet.addAction(UIAlertAction(title: R._string.common.cancel, style: .cancel))
        self.present(actionSheet, animated: true)
    }

    private func displayMenu() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: R._string.view_message.violationReport, style: .default, handler: { [unowned self] _ in
            self.displaySendingViolationConfirmation()
        }))
        actionSheet.addAction(UIAlertAction(title: R._string.common.cancel, style: .cancel))
        self.present(actionSheet, animated: true)
    }

    private func displaySendingViolationConfirmation() {
        let alert = UIAlertController.init(title: R._string.view_message.confirmationSendingReport, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: R._string.view_message.sendViolationReport, style: .default, handler: { _ in
            self.violationReportEvent.onNext(self.field)
        }))
        alert.addAction(UIAlertAction.init(title: R._string.common.cancel, style: .default, handler: nil))
        self.present(alert, animated: true)
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
        // Frame画面サイズより大きくなってしまうので画面サイズのwidthのサイズへ微修正している
        self.lipImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
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

    public static func generate(displayImage: UIImage, postField: PostDomainModel, fromMyPostList: Bool = false) -> UIViewController {
        guard let vc = R.storyboard.postLipDetail.postLipDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(displayImage: displayImage, postModel: postField, fromMyPostList: fromMyPostList))
        return vc
    }

}
