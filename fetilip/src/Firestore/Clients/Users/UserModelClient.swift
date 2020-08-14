//
//  UserModelClient.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore

/**
* Communication client model with firestore users collection protocol.
*/
protocol UsersModelClientProtocol {

    func setInitialData(params: (email: String, uid: String)) -> Single<()>

    func updateUserName(userName: String) -> Single<()>

    func updateUserProfile(profile: String) -> Single<()>

    /**
     * Fetch user data using user document reference.
     *
     * - Parameters:
     *  - userRef: User document reference.
     *
     * - Returns: Single<UserEntity>
     */
    func getUserData(userRef: DocumentReference) -> Single<UserModel.FieldType>

    /**
     * Update user profile image reference.
     *
     * - Parameters:
     *  - userRef: User document reference.
     *
     * - Returns: Single<UserEntity>
     */
    func updateUserProfileReference(userRef: DocumentReference, storagePath: String) -> Single<()>

}

/**
 * Communication client model with firestore users collection.
 */
public struct UsersModelClient: UsersModelClientProtocol {

    public init() {}

    /// Initial commit users document.
    // TODO: Unuse
    func setInitialData(params: (email: String, uid: String)) -> Single<()> {
        let fields = UsersRequests.initialCommit(email: params.email,
                                                 uid: params.uid).parameters
        return Firestore.firestore().rx.setData(UserModel.self, documentRef: UserModel.makeDocumentRef(id: params.uid), fields: fields)
    }

    // TODO: Unuse
    public func updateUserName(userName: String) -> Single<()> {
        // TODO: Make common.
        guard let uid = LoginAccountData.uid else {
            return Single.create { observer in
                observer(.error(FirebaseUser.AuthError.currentUserNotFound))
                return Disposables.create()
            }
        }
        let fields = UsersRequests.updateUserName(userName: userName).parameters
        return Firestore.firestore().rx.updateData(UserModel.self, documentRef: UserModel.makeDocumentRef(id: uid), fields: fields)
    }

    // TODO: Unuse
    public func updateUserProfile(profile: String) -> Single<()> {
        // TODO: Make common.
        guard let uid = LoginAccountData.uid else {
            return Single.create { observer in
                observer(.error(FirebaseUser.AuthError.currentUserNotFound))
                return Disposables.create()
            }
        }
        let fields = UsersRequests.updateProfile(userProfile: profile).parameters
        return Firestore.firestore().rx.updateData(UserModel.self, documentRef: UserModel.makeDocumentRef(id: uid), fields: fields)

    }

    /**
     * Fetch user data using user document reference.
     *
     * - Parameters:
     *  - userRef: User document reference.
     *
     * - Returns: Single<UserEntity>
     */
    public func getUserData(userRef: DocumentReference) -> Single<UserModel.FieldType> {
        return Firestore.firestore().rx.getDocument(UserModel.self, documentReference: userRef)
    }

    /**
     * Update user profile image reference.
     *
     * - Parameters:
     *  - userRef: User document reference.
     *
     * - Returns: Single<UserEntity>
     */
    public func updateUserProfileReference(userRef: DocumentReference, storagePath: String) -> Single<()> {
        let fields = UsersRequests.updateUserProfileStoragePath(storagePath: storagePath).parameters
        return Firestore.firestore().rx.updateData(UserModel.self, documentRef: userRef, fields: fields)
    }

}
