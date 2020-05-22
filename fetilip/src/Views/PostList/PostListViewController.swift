//
//  PostListViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * PostListViewController,
 */
class PostListViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = PostListViewModel

    var viewModel: ViewModel = PostListViewModel()

    // MARK: - Init process

    struct Dependency {
        let viewModel: PostListViewController.ViewModel
    }

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: - Outlets

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribeUI()
    }

}

extension PostListViewController {

    private func composeUI() {
        // Delete under bar line in navigation controller.
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let item = UIImageView(image: R.image.feti_word())
        self.navigationItem.titleView = item
    }

    /// Bind UI from view model outputs.
    private func subscribeUI() {

    }

    /// Transition post lip page.
    private func transitionPostLipScene() {
        let vc = PostLipViewControllerGenerator.generate()
        self.present(vc, animated: true)
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
