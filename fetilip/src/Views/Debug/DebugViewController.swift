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

    /// 戻るボタン
    @IBOutlet private weak var backButton: UIButton!

    /// 匿名ログインボタン
    @IBOutlet private weak var anonymousLoginButton: UIButton!

    /// ログイン中のユーザーのボタン
    @IBOutlet private weak var loginUserInfoLabel: UILabel!

    /// ログアウトボタン
    @IBOutlet private weak var logoutButton: UIButton!

    /// 画像アップロードボタン
    @IBOutlet private weak var uploadButton: UIButton!

    /// アップロードする画像
    @IBOutlet private weak var uploadImageView: UIImageView!

    /// アップロード後の画像URL
    @IBOutlet private weak var uploadedImageUrlLabel: UILabel!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        viewModel?.checkLogined()
    }

}

// MARK: Private function

extension DebugViewController {

    private func subscribe() {
        // 前の画面へ戻る
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)

        // 匿名ログインボタン
        anonymousLoginButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.anonymousLogin()
        }).disposed(by: rx.disposeBag)

        // ログアウトボタン
        logoutButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.logout()
        }).disposed(by: rx.disposeBag)

        // アップロードボタン
        uploadButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel?.uploadImage(image: self?.uploadImageView.image)
        }).disposed(by: rx.disposeBag)

        // アップロード後の画像URL
        viewModel?.uploadedImageUrlDriver
            .drive(uploadedImageUrlLabel.rx.text)
            .disposed(by: rx.disposeBag)

        // ログイン情報描画
        viewModel?.loginInfoDriver
            .drive(loginUserInfoLabel.rx.text)
            .disposed(by: rx.disposeBag)

        // エラー監視
        viewModel?.errorObservable.subscribe(onNext: { [weak self] message in
            let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }).disposed(by: rx.disposeBag)

        // ログイン状態監視
        viewModel?.loginStateDriver
            .map { !$0 }
            .drive(logoutButton.rx.isHidden)
            .disposed(by: rx.disposeBag)
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
