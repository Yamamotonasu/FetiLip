//
//  PostLipDetailViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

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

    var image: UIImage?

    // MARK: - Properties

    let transitionController: ZoomTransitionController = ZoomTransitionController()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lipImageView.image = self.image
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
