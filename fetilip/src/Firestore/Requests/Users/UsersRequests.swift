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

    case initialCommit(email: String, uid: String, createdAt: Date, updatedAt: Date)

    var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .initialCommit(let email, let uid, let createdAt, let updatedAt):
            params[Fields.Key.email.rawValue] = email
            params[Fields.Key.uid.rawValue] = uid
            params[Fields.Key.createdAt.rawValue] = createdAt
            params[Fields.Key.updatedAt.rawValue] = updatedAt
            return params
        }
    }

}
