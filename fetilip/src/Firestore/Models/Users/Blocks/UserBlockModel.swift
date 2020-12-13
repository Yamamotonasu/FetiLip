//
//  UserBlockModel.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

public struct UserBlockModel: FirestoreDatabaseCollection {

    public typealias FieldType = UserBlockEntity

    public static let collectionName = "userBlocks"

    public let id: String

    public let fields: FieldType?

    public init(id: String, fields: FieldType?) {
        self.id = id
        self.fields = fields
    }

}
