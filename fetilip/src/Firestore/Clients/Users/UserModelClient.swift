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
 * Communication with firestore users collection.
 */
public struct UsersModelClient {

    public init() {}

    // もうちょっと調整したい
    func setInitialData(documentRef: DocumentReference, params: (phone: String, email: String, uid: String, createdAt: Date, updatedAt: Date)) -> Single<()> {
        let fields = UsersRequests.initialCommit(phone: params.phone, email: params.email, uid: params.uid, createdAt: params.updatedAt, updatedAt: params.updatedAt).parameters
        return Firestore.firestore().rx.setData(UserModel.self, documentRef: documentRef, fields: fields)
    }

    public func updateData(_ type: UserModel, documentRef: DocumentReference, fields: [String: Any]) -> Single<()> {
        return Single.create { observer in
            documentRef.updateData(fields) { error in
                if let error = error {
                    log.error(error)
                    observer(.error(error))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }

}
