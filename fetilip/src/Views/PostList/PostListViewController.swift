//
//  PostListViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift

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
    var viewModel: PostListViewModelProtocol?

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: Outlets

    @IBOutlet weak var passText1: UITextField!

    @IBOutlet weak var passText2: UITextField!

    @IBOutlet weak var titleLabel: UILabel!

    var input: (Observable<String>, Observable<String>)!

    var dependency: (ValidationShare)!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        input = (passText1.rx.text.orEmpty.asObservable(), passText2.rx.text.orEmpty.asObservable())
        dependency = Validation()
        self.viewModel = PostListViewModel(input: input, dependency: dependency)
        subscribe()
    }

}

extension PostListViewController {

    private func subscribe() {

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
