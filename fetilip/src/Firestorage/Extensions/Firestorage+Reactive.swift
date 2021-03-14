//
//  Firestorage+Reactive.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/19.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseStorage
import UIKit

extension Reactive where Base: Storage {

    /**
     * Upload image to Firebase storage.
     *
     * - Parameters:
     *  - uid: Firebase authentication uid.
     *  - image: Upload image.
     *  - rootStoragePath: Root path of storage for saving image.
     * - Returns: Saved storage full path.
     */
    func uploadImage(uid: String, image: UIImage, rootStoragePath: String) -> Single<StorageReference> {
        return Single.create { observer in
            let uuid: String = NSUUID().uuidString
            let storageRef: StorageReference = Storage.storage().reference().child("\(rootStoragePath)").child("\(uid)").child("\(uid)_\(uuid).jpeg")
            let imageData: Data = image.jpeg(.medium)
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let e = error {
                    observer(.failure(FirestorageError.failedUploadImage("Failed uploading image at firestorage. reason: \(e.localizedDescription)")))
                }
                if let _ = metadata {
                    observer(.success(storageRef))
                } else {
                    observer(.failure(FirestorageError.failedUploadImage("Unexpected error occured.")))
                }
            }
            return Disposables.create()
        }
    }

}
