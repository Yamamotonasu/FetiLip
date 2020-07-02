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

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
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
