//
//  PostModelClient.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseStorage

protocol PostModelClientProtocol {

    func postImage(uid: String, review: String, imageRef: StorageReference) -> Single<()>

    func getPostList(limit: Int, startAfter: DocumentSnapshot?) -> Single<([PostModel.FieldType], [DocumentSnapshot])>

    func getSpecifyUserPostList(targetUid: String, limit: Int, startAfter: DocumentSnapshot?) -> Single<([PostModel.FieldType], [DocumentSnapshot])>

    func getImage() -> Single<[PostModel.FieldType]>

    func deletePost(targetReference: DocumentReference) -> Single<()>

}

/**
 * Communication client model with Firestore posts collection.
 */
public class PostModelClient: PostModelClientProtocol, RequiredLogin {

    public init() {}

    func postImage(uid: String, review: String, imageRef: StorageReference) -> Single<()> {
        let db = Firestore.firestore()
        let userRef: DocumentReference = db.document("/version/1/users/\(uid)")
        let fields = PostsRequests.postImage(review: review, userRef: userRef, userUid: uid, imageRef: imageRef.fullPath).parameters
        return Firestore.firestore().rx.addData(PostModel.self, collectionRef: PostModel.makeCollectionRef(), fields: fields)
    }

    func getPostList(limit: Int, startAfter: DocumentSnapshot? = nil) -> Single<([PostModel.FieldType], [DocumentSnapshot])> {
        if let start = startAfter {
            return Firestore.firestore().rx.get(PostModel.self, query: PostModel.pagingCollectionRef(limit: limit, startAfter: start))
        } else {
            return Firestore.firestore().rx.get(PostModel.self, query: PostModel.pagingCollectionRef(limit: limit))
        }
    }

    func getSpecifyUserPostList(targetUid: String, limit: Int, startAfter: DocumentSnapshot? = nil) -> Single<([PostModel.FieldType], [DocumentSnapshot])> {
        if let start = startAfter {
            let ref: CollectionReference = PostModel.makeCollectionRef()
            let query = PostModel.specifyPost(baseQuery: ref, targetUid: targetUid)
            let paging = PostModel.pagingWithQuery(baseQuery: query, limit: limit, startAfter: start)
            return Firestore.firestore().rx.get(PostModel.self, query: paging)
        } else {
            let ref: CollectionReference = PostModel.makeCollectionRef()
            let query = PostModel.specifyPost(baseQuery: ref, targetUid: targetUid)
            let paging = PostModel.pagingWithQuery(baseQuery: query, limit: limit)
            return Firestore.firestore().rx.get(PostModel.self, query: paging)
        }
    }

    func getImage() -> Single<[PostModel.FieldType]> {
        Firestore.firestore().rx.get(PostModel.self, collectionRef: PostModel.makeCollectionRef())
    }

    func deletePost(targetReference: DocumentReference) -> Single<()> {
        return Firestore.firestore().rx.deleteDocument(documentReference: targetReference)
    }

}
