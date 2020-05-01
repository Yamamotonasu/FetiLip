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

    public func setData(_ type: UserModel, documentRef: DocumentReference, fields: [String: Any]) -> Single<()> {
        return Single.create { observer in
            documentRef.setData(fields) { error in
                if let e = error {
                    log.error(e.localizedDescription)
                    observer(.error(e))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
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
