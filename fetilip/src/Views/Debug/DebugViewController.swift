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

// Rule
// 1, Define "initViewModel" function to initialize the ViewModel
// 2,

/**
 * Debug View Controller.
 *  - Architecture test.
 */
class DebugViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: View model

    typealias ViewModel = DebugViewModel

    lazy var viewModel: ViewModel = DebugViewModel(dependency: ((usersModelClient: UsersModelClient(), authModel: UsersAuthModel())))

    // MARK: Init process

    struct Dependency {
        // Write dependency object.
    }

    func inject(with dependency: DebugViewController.Dependency) {
        // Write DI process.
    }

    // MARK: Outlets

    /// Back button
    @IBOutlet private weak var backButton: UIButton!

    /// Anonymous login button.
    @IBOutlet private weak var anonymousLoginButton: UIButton!

    /// UILabel displaying user infomation.
    @IBOutlet private weak var loginUserInfoLabel: UILabel!

    /// Logout button.
    @IBOutlet private weak var logoutButton: UIButton!

    /// UIButton for uploading some image.
    @IBOutlet private weak var uploadButton: UIButton!

    /// UIImage to upload to firestore.
    @IBOutlet private weak var uploadImageView: UIImageView!

    /// After upload image url.
    @IBOutlet private weak var uploadedImageUrlLabel: UILabel!

    /// Text field for enternig user name.
    @IBOutlet private weak var userNameTextField: UITextField!

    /// UIButton for saving user name.
    @IBOutlet private weak var saveUserNameButton: UIButton!

    /// Text field for entering user profile.
    @IBOutlet private weak var profileTextField: UITextField!

    /// UIButton for saving user profile.
    @IBOutlet private weak var saveUserProfileButton: UIButton!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        subscribeUI()
        viewModel.checkLogined()
    }

}

// MARK: Private function

extension DebugViewController {

    /// Init view model
    private func initViewModel() -> ViewModel {
        return DebugViewModel(dependency: ((usersModelClient: UsersModelClient(), authModel: UsersAuthModel())))
    }

    /// Subscribe UI Actions.
    private func subscribe() {
        // 匿名ログインボタン
        anonymousLoginButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel.anonymousLogin()
        }).disposed(by: rx.disposeBag)

        // ログアウトボタン
        logoutButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel.logout()
        }).disposed(by: rx.disposeBag)

        // アップロードボタン
        uploadButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel.uploadImage(image: self?.uploadImageView.image)
        }).disposed(by: rx.disposeBag)
    }

    /// Bind UI
    private func subscribeUI() {
        let input = ViewModel.Input(userNameObservable: userNameTextField.rx.text.orEmpty.asObservable(),
                                    userProfileObservable: profileTextField.rx.text.orEmpty.asObservable(),
                                    tapBackButton: backButton.rx.tap.asSignal(),
                                    tapLoginButton: anonymousLoginButton.rx.tap.asSignal(),
                                    tapLogoutButton: logoutButton.rx.tap.asSignal(),
                                    tapUploadImageButton: uploadButton.rx.tap.asSignal(),
                                    tapSaveNameButton: saveUserNameButton.rx.tap.asSignal(),
                                    tapSaveProfileButton: saveUserProfileButton.rx.tap.asSignal())

        let output = viewModel.transform(input: input)

        output.backEvent.emit(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)

        // アップロード後の画像URL
        output.uploadedImageUrlDriver
            .drive(uploadedImageUrlLabel.rx.text)
            .disposed(by: rx.disposeBag)

        // ログイン情報描画
        output.loginInfoDriver
            .drive(loginUserInfoLabel.rx.text)
            .disposed(by: rx.disposeBag)

        // エラー監視
        output.errorObservable.subscribe(onNext: { [weak self] message in
            let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }).disposed(by: rx.disposeBag)

        // ログイン状態監視
        output.loginStateDriver
            .map { !$0 }
            .drive(logoutButton.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }

}

/**
 * DebugViewController Generator
 */
final class DebugViewControllerGenerator {

    private init() {}

    public static func generate() -> UIViewController {
        guard let vc = R.storyboard.debug.debugViewController() else {
            return UIViewController()
        }
        vc.inject(with: .init())
        return vc
    }

}
