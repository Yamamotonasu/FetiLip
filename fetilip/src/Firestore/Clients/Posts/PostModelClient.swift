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

    func postImage(image: String) -> Single<()>

    func getPostList() -> Single<[PostModel]>

    // For test function.
    func getImage() -> Single<[PostModel]>

}

/**
 * Communication client model with Firestore posts collection.
 */
public class PostModelClient: PostModelClientProtocol, RequiredLogin {

    public init() {}

    func postImage(image: String) -> Single<()> {
        guard let uid = LoginAccountData.uid else {
            return Single.create { observer in
                observer(.error(FirebaseUser.AuthError.currentUserNotFound))
                return Disposables.create()
            }
        }
        let fields = PostsRequests.postImage(userId: uid, image: image).parameters
        return Firestore.firestore().rx.addData(PostModel.self, collectionRef: PostModel.makeCollectionRef(), fields: fields)
    }

    func getPostList() -> Single<[PostModel]> {
        guard let _ = LoginAccountData.uid else {
            return Single.create { observer in
                observer(.error(FirebaseUser.AuthError.currentUserNotFound))
                return Disposables.create()
            }
        }
        return Firestore.firestore().rx.get(PostModel.self, collectionRef: PostModel.makeCollectionRef())
    }

    func getImage() -> Single<[PostModel]> {
        Firestore.firestore().rx.get(PostModel.self, collectionRef: PostModel.makeCollectionRef())
    }
    
}
