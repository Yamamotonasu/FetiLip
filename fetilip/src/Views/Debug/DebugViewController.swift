//
//  DebugViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * Debugやテスト用ViewController
 */
class DebugViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: Init process

    struct Dependency {
        let viewModel: DebugViewController.ViewModel
    }

    typealias ViewModel = DebugViewModelProtocol

    var viewModel: DebugViewModelProtocol?

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: Outlets

    @IBOutlet private weak var backButton: UIButton!

    @IBOutlet private weak var anonymousLoginButton: UIButton!

    @IBOutlet private weak var loginUserInfoLabel: UILabel!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

}

// MARK: Private function

extension DebugViewController {

    private func subscribe() {
        /// 前の画面へ戻る
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)

        /// 匿名ログインボタン
        anonymousLoginButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.anonymousLogin()
        }).disposed(by: rx.disposeBag)

    }

}


/**
 * DebugViewController初期化用コンテナ
 */
final class DebugViewControllerContainer {

    private init() {}

    public static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.debug.debugViewController() else {
            return UIViewController()
        }
        vc.inject(with: .init(viewModel: DebugViewModel()))
        return vc
    }

}
