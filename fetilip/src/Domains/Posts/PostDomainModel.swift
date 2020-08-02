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

/**
 * Convert entity to domain model.
 */
struct PostDomainModel: DomainModelProtocol {

    typealias Input = PostEntity

    typealias Output = Self

    /// Reference of user document associated with document.
    let userRef: DocumentReference

    /// Post image.
    let imageRef: String

    /// Review lip image.
    let review: String

    /// Date posted.
    let createdAt: Timestamp

    /// Date posted display user.
    let displayCreatedAt: String

    static func convert(_ model: Input) -> Output {
        let f = DateFormatter()
        f.setTemplate(.full)
        return self.init(userRef: model.userRef,
                         imageRef: model.imageRef,
                         review: model.review ?? "",
                         createdAt: model.createdAt,
                         displayCreatedAt: f.string(from: model.createdAt.dateValue()))
    }

}
