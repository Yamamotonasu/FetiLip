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
import FirebaseStorage

struct PostDomainModel: DomainModelProtocol {

    typealias Input = PostModel

    typealias Output = Self

    let userRef: DocumentReference

    /// Post image.
    let imageRef: String

    let review: String

    static func convert(_ model: PostModel.Fields) -> Self {
        return self.init(userRef: model.userRef, imageRef: model.imageRef, review: model.review ?? "")
    }

}
