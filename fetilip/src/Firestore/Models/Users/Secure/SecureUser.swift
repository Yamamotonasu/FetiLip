//
//  SecureUser.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/20.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Secure user model
 * - Prevent other users from getting information.
 */
public struct SecureUserModel: FirestoreDatabaseCollection {

    public typealias FieldType = _UserEntity

    public static let collectionName = "_users"

    public let id: String

    public let fields: FieldType?

    public init(id: String, fields: FieldType?) {
        self.id = id
        self.fields = fields
    }
    
}
