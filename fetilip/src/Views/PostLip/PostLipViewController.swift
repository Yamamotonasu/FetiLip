//
//  PostLipViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/10.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

/**
 * ViewController for posting lips.
 */
class PostLipViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = PostLipViewModel

    var viewModel: ViewModel = PostLipViewModel()

    // MARK: - Init process

    struct Dependency {
        // Write dependency object.
    }

    func inject(with dependency: PostLipViewController.Dependency) {
        // Write method inject process.
    }

    // MARK: - Outlets


    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

/**
 * PostLipViewController generator.
 */
final class PostLipViewControllerGenerator {

    public init() {}

    public static func generate() -> UIViewController {
        guard let vc = R.storyboard.postLip.postLipViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init())
        return vc
    }

}
