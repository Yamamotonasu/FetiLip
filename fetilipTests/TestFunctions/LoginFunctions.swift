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
    func login(email: String, password: String, completion: @escaping(Result<FirebaseUser, Error>) -> Void) {
        let _ = UsersAuthModel().loginWithEmailAndPassword(email: email, password: password).subscribe(onSuccess: { [weak self] user in
            self?.selfUid = user.uid
            completion(Result.success(user))
        }, onError: { [weak self] e in
            self?.selfUid = nil
            completion(Result.failure(e))
        })
    }

    /// Logout firebase authentication.
    func logout(completion: @escaping(Result<(), Error>) -> Void) {
        let _ = UsersAuthModel().logout().subscribe(onSuccess: { [weak self] _ in
            self?.selfUid = nil
            completion(Result.success(()))
        }, onError: { e in
            completion(Result.failure(e))
        })
    }

}
