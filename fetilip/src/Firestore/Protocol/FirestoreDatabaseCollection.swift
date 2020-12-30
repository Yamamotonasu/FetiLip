//
//  FirestoreDatabaseCollection.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

// Reference: https://gist.github.com/mono0926/ae6c491862370348ad4b4fcc7b4a5556

/**
 * Protocol representing the field of Firestore.
 */
public protocol FirestoreDatabaseCollection {

    associatedtype FieldType: Codable

    /// Collection name.
    static var collectionName: String { get }

    /// Document ID.
    var id: String { get }

    /// Document field.
    var fields: FieldType? { get }

    /// Init model
    init(id: String, fields: FieldType?)

    /// Create collection reference.
    static func makeCollectionRef() -> CollectionReference

    /// Create sub collection query.
    static func makeSubCollectionQuery() -> Query

    /// Create document reference. (Use without instantiating.)
    static func makeDocumentRef(id: String) -> DocumentReference

    /// Create document reference. (After instantiating.)
    func makeDocumentRef() -> DocumentReference

}

// MARK: Default implementations

extension FirestoreDatabaseCollection {

    /// Init model.
    public init(id: String) {
        self.init(id: id, fields: nil)
    }

    public init(id: String, json: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            let decoded = try JSONDecoder().decode(FieldType.self, from: data)
            self.init(id: id, fields: decoded)
        } catch {
            log.error(error)
            self.init(id: id)
        }
    }

    /// Create collection reference.
    public static func makeCollectionRef() -> CollectionReference {
        let root = AppSettings.FireStore.rootDocumentName
        return Firestore.firestore().document(root).collection(collectionName)
    }

    /// Create query with query cursor.
    /// TODO: FIx hard cording.
    public static func pagingCollectionRef(limit: Int, startAfter: DocumentSnapshot? = nil) -> Query {
        let root = AppSettings.FireStore.rootDocumentName
        let collectionRef = Firestore.firestore().document(root).collection(collectionName)
        if let start = startAfter {
            return collectionRef.order(by: "createdAt", descending: true).start(afterDocument: start).limit(to: limit)
        } else {
            return collectionRef.order(by: "createdAt", descending: true).limit(to: limit)
        }
    }

    /**
     * Paging with base query.
     * You may need to create an index in Firestore.
     *
     * - Parameters:
     *  - baseQuery: Base query.
     *  - limit: Acquisition number limit.
     *  - startAfter: Document last fetched.
     * - Returns: New query.
     */
    public static func pagingWithQuery(baseQuery: Query, limit: Int, startAfter: DocumentSnapshot? = nil) -> Query {
        if let start = startAfter {
            return baseQuery.order(by: "createdAt", descending: true).start(afterDocument: start).limit(to: limit)
        } else {
            return baseQuery.order(by: "createdAt", descending: true).limit(to: limit)
        }
    }

    /**
     *  Make subcollection reference.
     *
     *  - Parameters:
     *    - parentCollection: Parent collection type.
     *    - uid: Document uid in parent collection.
     *  - Returns: Sub collection reference.
     *
     */
    public static func makeSubCollectionRef<T: FirestoreDatabaseCollection>(parentCollection: T.Type, uid: String) -> CollectionReference {
        let root = AppSettings.FireStore.rootDocumentName
        return Firestore.firestore().document(root).collection(T.collectionName).document(uid).collection(Self.collectionName)
    }

    public static func makeSubCollectionQuery() -> Query {
        return Firestore.firestore().collectionGroup(collectionName)
    }

    /// Create document reference. (Use without instantiating.)
    public static func makeDocumentRef(id: String) -> DocumentReference {
        return Self.makeCollectionRef().document(id)
    }

    /// Create document reference. (After instantiating.)
    public func makeDocumentRef() -> DocumentReference {
        return Self.makeDocumentRef(id: id)
    }

    public func makeCollectionRef() -> CollectionReference {
        let root = AppSettings.FireStore.rootDocumentName
        return Firestore.firestore().document(root).collection(Self.collectionName)
    }

}

//extension Timestamp: TimestampType{}
