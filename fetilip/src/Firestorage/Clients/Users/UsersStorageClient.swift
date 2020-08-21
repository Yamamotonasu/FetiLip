//
//  UsersStorageClient.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/14.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Firebase

/**
 * Client model protocol for saving the image associated with the user model to storage.
 */
protocol UsersStorageClientProtocol {

    func uploadImage(uid: String, image: UIImage) -> Single<StorageReference>

}

/**
* Client model for saving the image associated with the user model to storage.
*/
struct UsersStorageClient: UsersStorageClientProtocol {

    public init() {}

    func uploadImage(uid: String, image: UIImage) -> Single<StorageReference> {
        return Storage.storage().rx.uploadImage(uid: uid, image: image, rootStoragePath: UserModel.collectionName)
    }

}
