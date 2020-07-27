//
//  UserEntity.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/27.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * User entity from firestore.
 */
public struct UserEntity: Codable {

    public let uid: String

    public let profile: String

    public let email: String

    public let userName: String

    public let userImageRef: String?

    public let createdAt: Timestamp

    public let updatedAt: Timestamp

    enum Key: String, CodingKey {

        case uid

        case profile

        case email

        case userName

        case userImageRef

        case createdAt

        case updatedAt

    }

}
