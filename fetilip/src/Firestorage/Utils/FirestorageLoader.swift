//
//  FirestorageLoader.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/19.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit
import RxSwift

struct FirestorageLoader {

    static func loadImage(storagePath path: String) -> Single<UIImage> {
        return Single.create { observer in
            Storage.storage().reference().child(path).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let e = error {
                    observer(.error(FirestorageError.failedGetImage(e.localizedDescription)))
                }
                if let data = data, let image = UIImage(data: data) {
                    observer(.success(image))
                } else {
                    observer(.error(FirestorageError.failedGetImage("Unexpected error occured.")))
                }
            }
            return Disposables.create()
        }
    }

}
