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

/**
 * Firebase auth user model protocol.
 */
protocol UserAuthModelProtocol {

    func createAnonymousUser() -> Single<FirebaseUser>

    func checkLogin() -> Single<FirebaseUser>

    func logout() -> Single<Void>

    func createUserWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser>

}

/**
 * Firebase auth user model.
 */
public struct UsersAuthModel: UserAuthModelProtocol {

    public init() {}

    /// Anonymous login with firebase auth.
    public func createAnonymousUser() -> Single<FirebaseUser> {
        return Single.create { observer in
            Auth.auth().signInAnonymously { _, error in
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

    /// Create user account with email and password.
    public func createUserWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser> {
        return Single.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
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
    public func checkLogin() -> Single<FirebaseUser> {
        return Single.create { observer in
            if let user = Auth.auth().currentUser {
                observer(.success(user))
            } else {
                observer(.error(User.AuthError.notLoginError))
            }
            return Disposables.create()
        }
    }

    /// Login.
    public func signInWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser> {
        return Single.create { observer in
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let _ = error {
                    observer(.error(User.AuthError.notLoginError))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                } else {
                    observer(.error(User.AuthError.notLoginError))
                }
            })
            return Disposables.create()
        }
    }

    /// Log out.
    public func logout() -> Single<Void> {
        return Single.create { observer in
            do {
                try Auth.auth().signOut()
                LoginAccountData.resetUserData()
                observer(.success(()))
            } catch let e {
                observer(.error(User.AuthError.failedLogout(error: e)))
            }
            return Disposables.create()
        }
    }



}
