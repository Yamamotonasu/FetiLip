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
import CodableFirebase

extension Reactive where Base: Firestore {

    /// Commit data without specifying document id.
    public func addData<T: FirestoreDatabaseCollection>(_ type: T.Type,
                                                        collectionRef: CollectionReference,
                                                        fields: Parameters) -> Single<()> {
        return Single.create { observer in
            collectionRef.addDocument(data: fields) { error in
                if let error = error {
                    log.error(error)
                    observer(.error(AuthErrorHandler.errorCode(error)))
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
                    observer(.error(AuthErrorHandler.errorCode(error)))
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
                    observer(.error(AuthErrorHandler.errorCode(error)))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    func get<T: FirestoreDatabaseCollection>(_ type: T.Type, query: Query) -> Single<([T.FieldType], [DocumentSnapshot])> {
        return Single.create { observer in
            query.getDocuments { snapshot, error in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                    return
                }
                guard let snap = snapshot else {
                    observer(.error(ApplicationError.unknown))
                    return
                }

                let results = snap.documents.compactMap { document -> T.FieldType? in
                    do {
                        let field = try FirestoreDecoder().decode(T.FieldType.self, from: document.data())
                        return field
                    } catch {
                        // TODO: Error handler
                        log.error(error)
                        return nil
                    }
                }

                let returns: ([T.FieldType], [DocumentSnapshot]) = (results, snap.documents)

                observer(.success(returns))
            }
            return Disposables.create()
        }
    }

    /// Fetch data specify collection.
    func get<T: FirestoreDatabaseCollection>(_ type: T.Type, collectionRef: CollectionReference) -> Single<[T.FieldType]> {
        return Single.create { observer in
            collectionRef.getDocuments { snapshot, error in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                    return
                }
                guard let snap = snapshot else {
                    observer(.error(ApplicationError.unknown))
                    return
                }

                let results = snap.documents.compactMap { document -> T.FieldType? in
                    do {
                        let field = try FirestoreDecoder().decode(T.FieldType.self, from: document.data())
                        return field
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

    func getSubCollection<T: FirestoreDatabaseCollection>(_ type: T.Type, subCollectionQuery: Query) -> Single<[T.FieldType]> {
        return Single.create { observer in
            subCollectionQuery.getDocuments { (snapshot, error) in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                    return
                }
                guard let snap = snapshot else {
                    observer(.error(ApplicationError.unknown))
                    return
                }
                let results = snap.documents.compactMap { document -> T.FieldType? in
                    do {
                        let field = try FirestoreDecoder().decode(T.FieldType.self, from: document.data())
                        return field
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

    /**
     * Fetch single document using document reference.
     */
    func getDocument<T: FirestoreDatabaseCollection>(_ type: T.Type, documentReference: DocumentReference) -> Single<T.FieldType> {
        return Single.create { observer in
            documentReference.getDocument { (snapshot, error) in
                if let e = error {
                    observer(.error(AuthErrorHandler.errorCode(e)))
                    return
                }
                guard let snap = snapshot, let data = snap.data() else {
                    observer(.error(ApplicationError.unknown))
                    return
                }
                do {
                    let field = try FirestoreDecoder().decode(T.FieldType.self, from: data)
                    observer(.success(field))
                } catch {
                    log.error(error)
                    observer(.error(ApplicationError.failedParseResponse))
                }
            }
            return Disposables.create()
        }
    }

    /**
     * Delete specify documents.
     * - Parameters:
     *  - documentReference: Target document reference to delete.
     * - Returns: Single<()>
     */
    func deleteDocument(documentReference: DocumentReference) -> Single<()> {
        return Single.create { observer in
            documentReference.delete { error in
                if let e = error {
                    observer(.error(e))
                } else {
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }

}

public enum ApplicationError: Error {
    case unknown
    case notFoundEntity(documentId: String)
    case notFoundJson
    case failedParseResponse
}

extension ApplicationError: LocalizedError {

    public var errorDescription: String? {
        return R._string.internalError
    }

}

enum SortType {
    case ascending
    case descending
    case outOfOrder
}
