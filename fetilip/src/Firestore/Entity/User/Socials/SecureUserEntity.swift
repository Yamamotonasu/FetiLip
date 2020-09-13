//
//  SecureUserEntity.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/20.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * Secure user entity
 * - Other users can get information.
 */
public struct UserSocialEntity: Codable {

    public let fetiPoint: Int

    public let postCount: Int

    public let createdAt: Timestamp

    public let updatedAt: Timestamp

    enum Key: String, CodingKey {

        case fetiPoint

        case postCount

        case createdAt

        case updatedAt

    }

}

enum FetiPointCriteria {

    case post

    var increasingValue: Int {
        switch  self {
        case .post:
            return 5
        }
    }

}
