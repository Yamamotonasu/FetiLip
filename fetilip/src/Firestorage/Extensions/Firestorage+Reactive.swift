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

    func uploadPostImage(image: UIImage, uid: String) -> Single<StorageReference>{
        return Single.create { observer in
            let uuid = NSUUID().uuidString
            let storageRef: StorageReference = Storage.storage().reference().child("posts/\(uid)").child("\(uid)_\(uuid).jpeg")
            let imageData = image.jpegData(compressionQuality: 0.01)!
            storageRef.putData(imageData, metadata: nil) { (metaData, error) in
                if let e = error {
                    observer(.error(FirestorageError.failedUploadImage("Failed uploading image at firestorage. reason: \(e.localizedDescription)")))
                }
                if let _ = metaData {
                    observer(.success(storageRef))
                } else {
                    observer(.error(FirestorageError.failedUploadImage("Unexpected error occured.")))
                }
            }
            return Disposables.create()
        }
    }
}
