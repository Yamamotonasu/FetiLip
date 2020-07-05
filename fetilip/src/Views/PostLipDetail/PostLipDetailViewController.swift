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
class PostLipDetailViewController: UIViewController, ViewControllerMethodInjectable {

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
    }

    private func subscribe() {
        backButton.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}

extension PostLipDetailViewController: ZoomAnimatorDelegate {

    func transitionWillStartWith(zoomAnimator: TransitionManager) {
    }

    func transitionDidEndWith(zoomAnimator: TransitionManager) {
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
