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
            var j = json
            // Timestamp → Date変換処理
            // あまりやりたくない処理。大体案考えたいなぁ
            j.forEach { (key: String, value: Any) in
                switch value {
                case let timestamp as Timestamp:
                    let date = timestamp.dateValue()
                    let jsonValue = Int((date.timeIntervalSince1970 * 1000).rounded())
                    j[key] = jsonValue
                    break
                default:
                    break
                }
            }
            let data = try JSONSerialization.data(withJSONObject: j)
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
