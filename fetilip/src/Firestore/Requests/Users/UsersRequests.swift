//
//  UsersRequests.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Data change request parameters to users document.
 */
enum UsersRequests: FirestoreRequest {

    typealias Fields = UserModel.FieldType

    /// First commit request parametes.
    case initialCommit(email: String)

    /// Update user name.
    case updateUserName(userName: String)

    /// Update user profile.
    case updateProfile(userProfile: String)

    /// Update user profile strage reference.
    case updateUserProfileStoragePath(storagePath: String)

    var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .initialCommit(let email):
            params[Fields.Key.email.rawValue] = email
            params[Fields.Key.createdAt.rawValue] = Date()
            params[Fields.Key.updatedAt.rawValue] = Date()
            params[Fields.Key.userName.rawValue] = ""
            params[Fields.Key.profile.rawValue] = ""
            return params
        case .updateUserName(let userName):
            params[Fields.Key.userName.rawValue] = userName
            params[Fields.Key.updatedAt.rawValue] = Date()
            return params
        case .updateProfile(let profile):
            params[Fields.Key.profile.rawValue] = profile
            params[Fields.Key.updatedAt.rawValue] = Date()
            return params
        case .updateUserProfileStoragePath(let storagePath):
            params[Fields.Key.userImageRef.rawValue] = storagePath
            return params
        }
    }

}
