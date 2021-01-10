//
//  EditPostViewController.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/10.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = EditPostViewModel

    let viewModel: ViewModel = EditPostViewModel()

    // MARK: - Init process

    struct Dependency {

    }

    func inject(with dependency: Dependency) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

final class EditPostViewControllerGenerator {

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init())
        return vc
    }

    static func generateWithNavigation() -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init())
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
