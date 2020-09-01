//
//  LoginConfirmViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/01.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginConfirmViewController: UIViewController {

    // MARK: - ViewModel

    typealias ViewModel = LoginConfirmViewModel

    private let viewModel: ViewModel = LoginConfirmViewModel(userAuthModel: UsersAuthModel())

    // MARK: - Properties

    private let createAnonymousUserEvent: PublishRelay<()> = PublishRelay<()>()

    // MARK: - Outlet

    @IBOutlet private weak var alreadyExistAccountButton: UIButton!

    @IBOutlet private weak var startAnonymousButton: UIButton!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        subscribeUI()
    }

    private func subscribe() {
        alreadyExistAccountButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.transitionToLoginScreen()
        }).disposed(by: rx.disposeBag)

        startAnonymousButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.createAnonymousUserEvent.accept(())
        }).disposed(by: rx.disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(createAnonymousUserEvent: createAnonymousUserEvent)
        let output = viewModel.transform(input: input)

        output.createAnonymousUserResult.retryWithAlert().subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)

        output.loading.subscribe(onNext: { bool in
            if bool {
                AppIndicator.show()
            } else {
                AppIndicator.dismiss()
            }
        }).disposed(by: rx.disposeBag)
    }

    private func transitionToLoginScreen() {

    }

}

final class LoginConfirmViewControllerGenerator {

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.loginConfirmViewController.loginConfirmViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
