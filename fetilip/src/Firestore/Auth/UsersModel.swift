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

    /// Login anonymous user.
    func createAnonymousUser() -> Single<FirebaseUser>

    /// Check logining. if login, return FirebaseUser, else return User.AuthError.notLoginError.
    func checkLogin() -> Single<FirebaseUser>

    /// Logout from firebase authentication system. if succeed return empty tuple, else return User.AuthError.failedLogout.
    func logout() -> Single<Void>

    /// Create user with email and password.
    func createUserWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser>

    /// Login with exists email and password.
    func loginWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser>

    /// Sign in with email and password.
    func signInWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser>

    /**
     * Upgrade perpetual accoutn with email and password from anonymous user.
     *
     * - Parameters:
     *  - email: Email adress
     *  - password: Password
     * - Returns: Single<FirebaseUser>
     */
    func upgradePerpetualAccountFromAnonymous(email: String, password: String, linkingUser user: FirebaseUser) -> Single<FirebaseUser>

    /**
     * Update user email adress associated with authentication.
     *
     * - Parameters:
     *  - email: Email adress
     * - Returns: Single<()>
     */
    func updateUserEmail(email: String) -> Single<()>

    /**
     * Authenticate again.
     *
     * - Parameters:
     *  - email: Email adress already registered.
     *  - password: Password already registerd.
     * - Returns: Signal<credential>
     *
     */
    func reauthenticateUser(email: String, password: String) -> Single<()>

    /**
     * Update user name.
     *
     * - Parameters:
     *  - name: Update user name
     * - Return Single<()>
     */
    func updateDisplayUserName(name: String?) -> Single<()>

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
                    observer(.error(AuthErrorHandler.errorCode(e)))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                } else {

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
                    observer(.error(AuthErrorHandler.errorCode(e)))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                } else {
                    observer(.error(User.AuthError.currentUserNotFound))
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
                observer(.error(User.AuthError.currentUserNotFound))
            }
            return Disposables.create()
        }
    }

    /// Sign up with email and password.
    public func loginWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser> {
        return Single.create { observer in
            Auth.auth().signIn(withEmail: email, password: password, completion: { (_, error) in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                } else {
                    observer(.error(User.AuthError.currentUserNotFound))
                }
            })
            return Disposables.create()
        }
    }

    /// Login
    public func signInWithEmailAndPassword(email: String, password: String) -> Single<FirebaseUser> {
        return Single.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                } else {
                    observer(.error(User.AuthError.currentUserNotFound))
                }
            }
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
            } catch {
                observer(.error(User.AuthError.failedLogout))
            }
            return Disposables.create()
        }
    }

    public func upgradePerpetualAccountFromAnonymous(email: String, password: String, linkingUser user: FirebaseUser) -> Single<FirebaseUser> {
        return Single.create { observer in
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user.link(with: credential) { (_, error) in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                }
                if let user = Auth.auth().currentUser {
                    observer(.success(user))
                }
            }
            return Disposables.create()
        }
    }

    public func updateUserEmail(email: String) -> Single<()> {
        return Single.create { observer in
            guard let user = Auth.auth().currentUser else {
                observer(.error(User.AuthError.currentUserNotFound))
                return Disposables.create()
            }

            if user.isAnonymous {
                observer(.error(User.AuthError.needToUpdateFromAnonymousUser))
            } else {
                user.updateEmail(to: email) { error in
                    if let e = error {
                        observer(.error(User.AuthError.failedUpdateEmail(reason: e.localizedDescription)))
                    } else {
                        observer(.success(()))
                    }
                }
            }
            return Disposables.create()
        }
    }

    public func reauthenticateUser(email: String, password: String) -> Single<()> {
        return checkLogin().flatMap { user in
            return Single.create { observer in
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                user.reauthenticate(with: credential) { (_, error) in
                    if let e = error {
                        observer(.error(AuthErrorHandler.errorCode(e)))
                    } else {
                        observer(.success(()))
                    }
                 }
                return Disposables.create()
            }
        }
    }

    public func updateDisplayUserName(name: String?) -> Single<()> {
        return checkLogin().flatMap { user in
            return Single.create { observer in
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let e = error {
                        observer(.error(e))
                    }
                    observer(.success(()))
                }
                return Disposables.create()
            }
        }
    }

}
