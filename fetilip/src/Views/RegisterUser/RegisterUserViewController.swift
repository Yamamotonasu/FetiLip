//
//  RegisterUserViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterUserViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - init

    struct Dependency {
        // Write properties
    }

    func inject(with dependency: Dependency) {
        // Write inject process.
    }

    typealias ViewModel = RegisterUserViewModel

    private let viewModel: ViewModel = RegisterUserViewModel(userAuthModel: UsersAuthModel())

    // MARK: - Outlets

    @IBOutlet private weak var emailTextView: UITextView!

    @IBOutlet private weak var emailErrorLabel: UILabel!

    @IBOutlet private weak var passwordTextView: UITextView!

    @IBOutlet private weak var passwordErrorLabel: UILabel!

    @IBOutlet private weak var registerButton: UIButton!

    // MARK: - Properties

    private lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "✗", style: .done, target: self, action: #selector(close))

    // MARK: - LifeCycle

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
        self.navigationItem.title = R._string.registerUserScreentTitle

        self.navigationController?.navigationBar.barTintColor = FetiLipColors.theme()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2

        self.emailTextView.keyboardType = .emailAddress
        self.passwordTextView.isSecureTextEntry = true
        self.passwordTextView.keyboardType = .emailAddress
    }

    private func subscribeUI() {
        let input = ViewModel.Input(passwordTextObservable: passwordTextView.rx.text.asObservable(),
                                    emailTextObservable: emailTextView.rx.text.asObservable(),
                                    registerTapEvent: registerButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.emailValidatedDriver.drive(emailErrorLabel.rx.text).disposed(by: rx.disposeBag)

        output.passwordValidatedDriver.drive(passwordErrorLabel.rx.text).disposed(by: rx.disposeBag)

        output.enableRegisterButtonDriver.drive(onNext: { [unowned self] enabled in
            self.registerButton.alpha = enabled ? 1 : 0.5
        }).disposed(by: rx.disposeBag)

        output.registerResult.retryWithAlert().subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true) {
                AppAlert.show(message: R._string.success.registerUserSuccess, alertType: .success)
            }
        }).disposed(by: rx.disposeBag)
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

}

final class RegisterUserViewControllerGenerator {

    private init() {}

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.registerUser.registerUserViewController() else {
            assertionFailure()
            return UIViewController()
        }
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
