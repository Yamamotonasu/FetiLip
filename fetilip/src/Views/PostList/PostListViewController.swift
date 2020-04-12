//
//  PostListViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

/**
 * 投稿一覧
 */
class PostListViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: Init process

    struct Dependency {
        let viewModel: PostListViewController.ViewModel
    }

    typealias ViewModel = PostListViewModelProtocol

    // Memo: TabBarのルートビューなので初期値を代入
    var viewModel: PostListViewModelProtocol? = PostListViewModel()

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

/**
 * PostListViewController Generator
 */
final class PostListViewControllerGenerator {

    private init() {}

    public static func generate(viewModel: PostListViewController.ViewModel) -> UIViewController {
        guard let vc = R.storyboard.postList.postListViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(viewModel: viewModel))
        return vc
    }

}
