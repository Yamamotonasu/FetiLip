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

    /// Commit data without specifying document id.
    public func addData<T: FirestoreDatabaseCollection>(_ type: T.Type,
                                                        collectionRef: CollectionReference,
                                                        fields: Parameters) -> Single<()> {
        return Single.create { observer in
            collectionRef.addDocument(data: fields) { error in
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

    /// Commit data with specifying document id.
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

    /// Update fields in specific document.
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

    /// Fetch data specify collection.
    func get<T: FirestoreDatabaseCollection>(_ type: T.Type, collectionRef: CollectionReference) -> Single<[T]> {
        return Single.create { observer in
            collectionRef.getDocuments { snapshot, error in
                if let e = error {
                    observer(.error(e))
                    return
                }
                guard let snap = snapshot else {
                    observer(.error(ApplicationError.unknown))
                    return
                }
                // compactMapでnil除去
                let results = snap.documents.compactMap { document -> T? in
                    do {
                        return try document.makeResult(id: document.documentID)
                    } catch {
                        // TODO: Error handler
                        log.error(error)
                        return nil
                    }
                }
                observer(.success(results))
            }
            return Disposables.create()
        }
    }

}

extension DocumentSnapshot {

    func makeResult<T: FirestoreDatabaseCollection>(id: String) throws -> T {
        guard exists else {
            throw ApplicationError.notFoundEntity(documentId: documentID)
        }
        let json = data()
        log.debug(json)
        guard let j = json else {
            throw ApplicationError.notFoundJson
        }
        return T(id: id, json: j)
    }

}

public enum ApplicationError: Error {
    case unknown
    case notFoundEntity(documentId: String)
    case notFoundJson
}
