//
//  Firestore+Reactive.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/03.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore

extension Reactive where Base: Firestore {

    public func setData<T: FirestoreDatabaseCollection>(_ type: T.Type,
                                                        documentRef: DocumentReference,
                                                        fields: Parameters) -> Single<()> {
        return Single.create { observer in
            documentRef.setData(fields) { error in
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

    public func updateData<T: FirestoreDatabaseCollection>(_ type: T.Type,
                                                           documentRef: DocumentReference,
                                                           fields: Parameters) -> Single<()> {
        return  Single.create { observer in
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
