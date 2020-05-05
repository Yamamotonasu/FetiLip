//
//  UserModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

/**
 * UserModel firestore
 */
public struct UserModel: FirestoreDatabaseCollection {

    public static let collectionName = "users"

    public let id: String

    public let fields: Fields?

    // 構造
    public struct Fields: Codable {

        public let uid: String

        public let profile: String

        public let email: String

        public let userName: String

        public let phoneNumber: String

        public let createdAt: Date

        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {

            case uid

            case profile

            case email

            case userName

            case phoneNumber

            case createdAt

            case updatedAt

        }

    }

    static subscript(key: Self.Fields.CodingKeys) -> String {
        return ""
    }

    public init(id: String, fields: Fields?) {
        self.id = id
        self.fields = fields
    }

}
