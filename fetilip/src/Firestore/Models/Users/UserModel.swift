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

    public typealias FieldType = UserEntity

    public static let collectionName = "users"

    public let id: String

    public let fields: FieldType?

    public init(id: String, fields: FieldType?) {
        self.id = id
        self.fields = fields
    }

}
