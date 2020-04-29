//
//  MyPageViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * マイページ
 */
class MyPageViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: Init process

    struct Dependency {
        let viewModel: MyPageViewController.ViewModel
    }

    typealias ViewModel = MyPageViewModelProtocol

    // Memo: TabBarのルートビューなので初期値を代入
    var viewModel: MyPageViewModelProtocol? = MyPageViewModel()

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: Outlets

    /// デバッグ用画面へ遷移する為の
    @IBOutlet private weak var debugButton: UIButton!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

}

// MARK: Private functions

extension MyPageViewController {

    /// Rx subscribe
    private func subscribe() {
        debugButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.transitionDebugScreen()
        }).disposed(by: rx.disposeBag)
    }

    /// デバッグ画面へ遷移する
    private func transitionDebugScreen() {
        let vc = DebugViewControllerGenerator.generate(viewModel: DebugViewModel(model: UsersAuthModel()))
        self.present(vc, animated: true)
    }

}

/**
 * MyPageViewController Generator
 */
final class MyPageViewControllerGenerator {

    private init() {}

    public static func generate(viewModel: MyPageViewController.ViewModel) -> UIViewController {
        guard let vc = R.storyboard.myPage.myPageViewController() else {
            return UIViewController()
        }
        vc.inject(with: .init(viewModel: viewModel))
        return vc
    }

}
