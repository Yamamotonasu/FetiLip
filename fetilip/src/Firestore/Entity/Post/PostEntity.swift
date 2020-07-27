//
//  PostEntity.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/27.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * Entity that 
 */
public struct PostEntity: Codable {

    public let review: String?

    public let userRef: DocumentReference

    public let imageRef: String

    public let createdAt: Timestamp

    public let updatedAt: Timestamp

    enum Key: String, CodingKey {

        case userId

        case review

        case userRef

        case imageRef

        case createdAt

        case updatedAt

    }

}
