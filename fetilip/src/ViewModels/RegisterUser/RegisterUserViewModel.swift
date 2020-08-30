//
//  RegisterUserViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegisterUserViewModelProtocol {

}

struct RegisterUserViewModel {

    init(userAuthModel: UserAuthModelProtocol) {
        self.userAuthModel = userAuthModel
    }

    let userAuthModel: UserAuthModelProtocol

}

extension RegisterUserViewModel: ViewModelType {

    struct Input {
        let passwordTextObservable: Observable<String?>
        let emailTextObservable: Observable<String?>
        let registerTapEvent: Signal<()>
    }

    struct Output {
        let passwordValidatedDriver: Driver<String>
        let emailValidatedDriver: Driver<String>
        let enableRegisterButtonDriver: Driver<Bool>
        let registerResult: Observable<()>
    }

    func transform(input: Input) -> Output {
        let validatePassword = input.passwordTextObservable.flatMapLatest { password -> Observable<String> in
            Observable.create { observer in
                let validator = PasswordValidator.validate(password) { $0.isNotEmpty().lessThanDigits().greaterThanDigits() }
                switch validator {
                case .invalid(let status):
                    observer.on(.next(status.errorDescription ?? ""))
                case .valid:
                    observer.on(.next(""))
                }
                return Disposables.create()
            }
        }

        let validateEmail = input.emailTextObservable.flatMapLatest { email -> Observable<String> in
            Observable.create { observer in
                let validator = EmailValidator.validate(email) { $0.isNotEmpty().validFormat() }
                switch validator {
                case .invalid(let status):
                    observer.on(.next(status.errorDescription ?? ""))
                case .valid:
                    observer.on(.next(""))
                }
                return Disposables.create()
            }
        }

        let combine = Observable.combineLatest(validateEmail, validatePassword) {
            (emailError: $0, passwordError: $1)
        }

        let combineText = Observable.combineLatest(input.emailTextObservable.flatMap { $0.flatMap(Observable.just) ?? Observable.empty() }, input.passwordTextObservable.flatMap { $0.flatMap(Observable.just) ?? Observable.empty() } ) {
            (email: $0, password: $1)
        }

        let validateRegisterButton = combine.flatMapLatest { pair -> Observable<Bool> in
            Observable.create { observer in
                observer.on(.next(pair.emailError.isEmpty && pair.passwordError.isEmpty))
                return Disposables.create()
            }
        }

        let registerSequence = input.registerTapEvent.asObservable().withLatestFrom(combineText).flatMapLatest { pair in
            self.userAuthModel.checkLogin().flatMap { user -> Single<FirebaseUser> in
                return self.userAuthModel.upgradePerpetualAccountFromAnonymous(email: pair.email, password: pair.password, linkingUser: user)
            }.flatMap { user -> Single<()> in
                return Single.create { observer in
                    observer(.success(()))
                    return Disposables.create()
                }
            }.asObservable()
        }

        return Output(passwordValidatedDriver: validatePassword.asDriver(onErrorJustReturn: ""),
                      emailValidatedDriver: validateEmail.asDriver(onErrorJustReturn: ""),
                      enableRegisterButtonDriver: validateRegisterButton.asDriver(onErrorJustReturn: true),
                      registerResult: registerSequence.asObservable())
    }

}
