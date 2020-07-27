//
//  PostsModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/17.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

/**
 * User posts model.
 */
public struct PostModel: FirestoreDatabaseCollection, FirestoreSubCollection {
    public typealias FieldType = PostEntity


    typealias RootCollectionModel = UserModel

    static var rootCollectionName: String = RootCollectionModel.collectionName

    public static let collectionName = "posts"

    public let id: String

    public let fields: FieldType?

    // Firestore key-value fields.

    public init(id: String, fields: FieldType?) {
        self.id = id
        self.fields = fields
    }

    /**
     * Make collection ref sub collection of users according uid.
     */
    static func makeSubCollectionRef(uid: String) -> CollectionReference {
        let root = AppSettings.FireStore.rootDocumentName
        return Firestore.firestore().document(root).collection(Self.rootCollectionName).document(uid).collection(Self.collectionName)
    }

}

protocol FirestoreSubCollection {

    associatedtype RootCollectionModel

    static var rootCollectionName: String { get set }

    static func makeSubCollectionRef(uid: String) -> CollectionReference

}
