//
//  PostsModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/17.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * User posts model.
 */
public struct PostModel: FirestoreDatabaseCollection {

    public static let collectionName = "posts"

    public let id: String

    public let fields: Fields?

    // Firestore key-value fields.
    public struct Fields: Codable {

        public let userId: String

        public let image: String

        public let createdAt: Date

        public let updatedAt: Date

        enum Key: String, CodingKey {

            case userId

            case image

            case createdAt

            case updatedAt

        }

    }

    public init(id: String, fields: Fields?) {
        self.id = id
        self.fields = fields
    }

}
