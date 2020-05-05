//
//  UsersRequests.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

enum UsersRequests {

    typealias Fields = UserModel.Fields

    case initialCommit(phone: String, email: String, uid: String, createdAt: Date, updatedAt: Date)

    var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .initialCommit(let phone, let email, let uid, let createdAt, let updatedAt):
            params[Fields.CodingKeys.uid.rawValue] = phone
            params[Fields.CodingKeys.email.rawValue] = email
            params[Fields.CodingKeys.uid.rawValue] = uid
            params[Fields.CodingKeys.createdAt.rawValue] = createdAt
            params[Fields.CodingKeys.updatedAt.rawValue] = updatedAt
            return params
        }
    }

}
