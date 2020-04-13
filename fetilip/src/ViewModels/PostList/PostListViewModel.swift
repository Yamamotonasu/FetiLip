//
//  PostListViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

protocol PostListViewModelProtocol {

}

struct PostListViewModel: PostListViewModelProtocol {

    let validatedPassword1: Observable<ValidationResult>

    let validatedPassword2: Observable<ValidationResult>

    init(input: (
        pass1: Observable<String>,
        pass2: Observable<String>
        ), dependency: (
        ValidationShare
        )) {
        validatedPassword1 = input.pass1.map { pass in
            dependency.validatePassword(password: pass)
        }
        .share(replay: 1, scope: .whileConnected)

        validatedPassword2 = Observable.combineLatest(input.pass1, input.pass2, resultSelector: dependency.validateCombinedPassword).share(replay: 1, scope: .whileConnected)
    }



}

protocol ValidationShare {
    func validatePassword(password: String) -> ValidationResult
    func validateCombinedPassword(pass1: String, pass2: String) -> ValidationResult
}

struct Validation: ValidationShare {

    public func validatePassword(password: String) -> ValidationResult {
        if password.count > 5 {
            return .ok(message: "ok password!")
        }
        return .failed(message: "invalid password...")
    }

    public func validateCombinedPassword(pass1: String, pass2: String) -> ValidationResult {
        if pass1 == pass2 {
            return .ok(message: "password1 = password2 ok!")
        }
        return .failed(message: "password1 != password2. not ok...")

    }
}

enum ValidationResult {
    case ok(message: String)
    case failed(message: String)
}
