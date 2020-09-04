//
//  LoginViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - ViewModel

    typealias ViewModel = LoginViewModel

    private let viewModel = LoginViewModel(userAuthModel: UsersAuthModel())

    // MARK: - Outlets

    @IBOutlet private weak var emailTextView: UITextView!

    @IBOutlet private weak var passwordTextView: UITextView!

    @IBOutlet private weak var loginButton: UIButton!

    // MARK: - Properties

    private lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "✗", style: .done, target: self, action: #selector(close))

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribeUI()
    }

    // MARK: - Functions

    private func composeUI() {
        // Setup navigation controller
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.title = R._string.loginScreenTitle

        self.navigationController?.navigationBar.barTintColor = FetiLipColors.theme()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }

    private func subscribeUI() {
        let input = ViewModel.Input(inputEmail: emailTextView.rx.text.asObservable(),
                                    inputPassword: passwordTextView.rx.text.asObservable(),
                                    tapLogin: loginButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.loginResult.retryWithAlert().subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true) {
                AppAlert.show(message: "ログインしました", alertType: .info)
            }
        }).disposed(by: rx.disposeBag)
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

}

final class LoginViewControllerGenerator {

    private init() {}

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.login.loginViewController() else {
            assertionFailure()
            return UIViewController()
        }
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
