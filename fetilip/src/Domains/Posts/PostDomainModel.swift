//
//  PostDomainModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/14.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct PostDomainModel: DomainModelProtocol {

    typealias Input = PostModel

    typealias Output = Self

    let userRef: DocumentReference

    /// Post image.
    let image: UIImage?

    let review: String

    static func convert(_ model: PostModel.Fields) -> Self {
//        if let base64 = Data(base64Encoded: model.image) {
//            let image = UIImage(data: base64)
//            return self.init(userRef: model.userRef,
//                             image: image,
//                             review: model.review ?? "")
//        }
        return self.init(userRef: model.userRef, image: nil, review: model.review ?? "")
    }

}
