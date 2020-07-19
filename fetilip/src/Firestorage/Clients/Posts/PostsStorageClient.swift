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

protocol PostsStorageClientProtocol {

    func uploadImage(uid: String, image: UIImage) -> Single<StorageReference>
}

struct PostsStorageClient: PostsStorageClientProtocol {

    public init() {}

    func uploadImage(uid: String, image: UIImage) -> Single<(StorageReference)> {
        return Storage.storage().rx.uploadPostImage(image: image, uid: uid)
    }

}
