//
//  UserEntity.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/27.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * User entity from firestore.
 */
public struct UserEntity: Codable {

    public let uid: String

    public let profile: String

    public let email: String

    public let userName: String

    public let userImage: String?

    public let createdAt: Date

    public let updatedAt: Date

    enum Key: String, CodingKey {

        case uid

        case profile

        case email

        case userName

        case phoneNumber

        case createdAt

        case updatedAt

    }
}
