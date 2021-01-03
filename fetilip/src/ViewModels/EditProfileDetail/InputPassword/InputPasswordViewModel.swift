//
//  InputPasswordViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol InputPasswordViewModelProtocol {

}

struct InputPasswordViewModel: InputPasswordViewModelProtocol {

}

extension InputPasswordViewModel: ViewModelType {

    struct Input {
        let passwordText: Observable<String?>
    }

    struct Output {
        let validPasswordDriver: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        // valid: return true
        // invalid: return false
        let validatedPassword = input.passwordText.flatMapLatest { password -> Observable<Bool> in
            Observable.create { observer in
                let validator = PasswordValidator.validate(password) { $0.isNotEmpty().lessThanDigits().greaterThanDigits() }
                switch validator {
                case .invalid:
                    observer.on(.next(false))
                case .valid:
                    observer.on(.next(true))
                }
                return Disposables.create()
            }
        }

        return Output(validPasswordDriver: validatedPassword.asDriver(onErrorJustReturn: true))
    }

}
