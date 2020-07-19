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

protocol PostModelClientProtocol {

    func postImage(uid: String, review: String, image: String) -> Single<()>

    func getPostList() -> Single<[PostModel.FieldType]>

    func getImage() -> Single<[PostModel.FieldType]>

}

/**
 * Communication client model with Firestore posts collection.
 */
public class PostModelClient: PostModelClientProtocol, RequiredLogin {

    public init() {}

    func postImage(uid: String, review: String, image: String) -> Single<()> {
        let db = Firestore.firestore()
        let userRef: DocumentReference = db.document("/version/1/users/\(uid)")
        let fields = PostsRequests.postImage(userId: uid, review: review, image: image, userRef: userRef).parameters
        return Firestore.firestore().rx.addData(PostModel.self, collectionRef: PostModel.makeCollectionRef(), fields: fields)
    }

    func getPostList() -> Single<[PostModel.Fields]> {
        return Firestore.firestore().rx.get(PostModel.self, collectionRef: PostModel.makeCollectionRef())
    }

    func getImage() -> Single<[PostModel.Fields]> {
        Firestore.firestore().rx.get(PostModel.self, collectionRef: PostModel.makeCollectionRef())
    }
    
}
