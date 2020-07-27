//
//  UserDomainModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/28.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

/**
 * User domain model.
 * Convert from "UserEntity".
 */
public struct UserDomainModel: DomainModelProtocol {

    typealias Input = UserEntity

    typealias Output = Self

    /// Display user name.
    let userName: String

    /// User profile image.
    let imageRef: String

    /// Whether the user has the original image.
    var hasImage: Bool {
        return !imageRef.isEmpty
    }

    static func convert(_ model: Input) -> Output {
        return self.init(userName: model.userName,
                         imageRef: model.userImageRef ?? "")
    }

}
