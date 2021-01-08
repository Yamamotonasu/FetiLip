//
//  ViolationReportEntity.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/08.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

public struct ViolationReportEntity: Codable, FirestoreEntity {

    public let targetUid: String

    public let targetPostId: String

    public let targetImageRef: String

    public let createdAt: Timestamp

    public let updatedAt: Timestamp

    enum Key: String, CodingKey {

        case targetUid

        case targetPostId

        case targetImageRef

        case createdAt

        case updatedAt

    }

}
