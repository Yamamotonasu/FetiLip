//
//  UsersAuthModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/06.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol UserAuthModelProtocol {

    func createAnonymousUser() -> Single<User>

    func checkLogin() -> Single<User>

}

/**
 * Firebase User Model
 */
public struct UsersAuthModel: UserAuthModelProtocol {

    public init() {}

    /// Anonymous login with firebase auth.
    public func createAnonymousUser() -> Single<User> {
        return Single.create { observer in
            Auth.auth().signInAnonymously { result, error in
                if let e = error {
                    observer(.error(User.AuthError.notInitialized(error: e)))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                }
            }
            return Disposables.create()
        }
    }

    /// Check the login status of the current user with firebase auth.
    public func checkLogin() -> Single<User> {
        return Single.create { observer in
            if let user = Auth.auth().currentUser {
                observer(.success(user))
            } else {
                observer(.error(User.AuthError.notLoginError))
            }
            return Disposables.create()
        }
    }

}

extension User {

    public enum AuthError: Error {
        case notInitialized(error: Error)
        case notLoginError
    }

}
