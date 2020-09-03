//
//  LoginViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelProtocol {

}

struct LoginViewModel: LoginViewModelProtocol {

    // MARK: - init

    init(userAuthModel: UserAuthModelProtocol) {
        self.userAuthModel = userAuthModel
        self.indicator = activity.asObservable()
    }

    // MARK: - Properties

    private let userAuthModel: UserAuthModelProtocol

    private let activity: ActivityIndicator = ActivityIndicator()

    private let indicator: Observable<Bool>

}

// MARK: - Functions

extension LoginViewModel {

    // TODO: Make common.

    private func emailValidate(email: String?) -> Observable<String> {
        Observable.create { observer in
            let validator = EmailValidator.validate(email) { $0.isNotEmpty().validFormat() }
            switch validator {
            case .invalid(let status):
                observer.on(.error(status))
            case .valid:
                observer.on(.next(email!))
            }
            return Disposables.create()
        }
    }

    private func passwordValidator(password: String?) -> Observable<String> {
        Observable.create { observer in
            let validator = PasswordValidator.validate(password) { $0.isNotEmpty().lessThanDigits().greaterThanDigits() }
            switch validator {
            case .invalid(let status):
                observer.on(.error(status))
            case .valid:
                observer.on(.next(password!))
            }
            return Disposables.create()
        }
    }

}

// MARK: - ViewModelType

extension LoginViewModel: ViewModelType {

    struct Input {
        let inputEmail: Observable<String?>
        let inputPassword: Observable<String?>
        let tapLogin: Signal<()>
    }

    struct Output {
        let loginResult: Observable<()>
        let isLoading: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let combine = Observable.combineLatest(input.inputEmail, input.inputPassword) {
            (email: $0, password: $1)
        }

        let loginSequenece: Observable<()> = input.tapLogin.asObservable().withLatestFrom(combine).flatMapLatest { pair in
            return Observable.zip(self.emailValidate(email: pair.email), self.passwordValidator(password: pair.password))
        }.flatMapLatest { (email, password) in
            self.userAuthModel.loginWithEmailAndPassword(email: email, password: password).trackActivity(self.activity)
        }.flatMapLatest { user in
            return Observable.create { observer in
                LoginAccountData.uid = user.uid
                observer.on(.next(()))
                return Disposables.create()
            }
        }

        return Output(loginResult: loginSequenece,
                      isLoading: indicator.asDriver(onErrorJustReturn: false))
    }


}
