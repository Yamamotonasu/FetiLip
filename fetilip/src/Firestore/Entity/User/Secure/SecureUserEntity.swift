//
//  SecureUserEntity.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/20.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Secure user entity
 * - Other users cannnot get information.
 */
public struct _UserEntity: Codable {

    public let email: String

    enum Key: String, CodingKey {

        case email

    }

}
