//
//  LoginFunctions.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/06/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
@testable import fetilip
import RxSwift

/**
 * Login function for unit tests.
 */
protocol LoginFunction: class {

    /// Cunnrent user's uid.
    var selfUid: String? { get set }

}

extension LoginFunction {

    /// Login firebase authentication.
    func login(email: String, password: String) {
        UsersAuthModel().loginWithEmailAndPassword(email: email, password: password).subscribe(onSuccess: { [weak self] user in
            self?.selfUid = user.uid
        }, onError: { [weak self] _ in
            self?.selfUid = nil
        }).disposed(by: DisposeBag())
    }

}
