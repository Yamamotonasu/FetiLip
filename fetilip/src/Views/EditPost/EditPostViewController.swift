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
        let postDomainModel: PostDomainModel
    }

    func inject(with dependency: Dependency) {
        self.postDomainModel = dependency.postDomainModel
    }

    // MARK: - Properties

    private var postDomainModel: PostDomainModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

final class EditPostViewControllerGenerator {

    static func generate(postDomainModel: PostDomainModel) -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(postDomainModel: postDomainModel))
        return vc
    }

    static func generateWithNavigation(postDomainModel: PostDomainModel) -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(postDomainModel: postDomainModel))
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
