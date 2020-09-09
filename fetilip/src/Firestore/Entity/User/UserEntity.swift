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
public struct UserEntity: Codable, FirestoreEntity {

    public let profile: String?

    public let userName: String

    public let userImageRef: String?

    public let createdAt: Timestamp

    public let updatedAt: Timestamp

    enum Key: String, CodingKey {

        case profile

        case email

        case userName

        case userImageRef

        case createdAt

        case updatedAt

    }

}
