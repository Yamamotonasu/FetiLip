//
//  PostsStorageClient.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/19.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Firebase

/**
 * Client model protocol for saving the image associated with the post model to storage.
 */
protocol PostsStorageClientProtocol {

    func uploadImage(uid: String, image: UIImage) -> Single<StorageReference>

}

/**
* Client model for saving the image associated with the post model to storage.
*/
struct PostsStorageClient: PostsStorageClientProtocol {

    public init() {}

    func uploadImage(uid: String, image: UIImage) -> Single<(StorageReference)> {
        return Storage.storage().rx.uploadImage(uid: uid, image: image, rootStoragePath: PostModel.collectionName)
    }

}
