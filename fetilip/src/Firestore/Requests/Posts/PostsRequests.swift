//
//  PostsRequests.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

public enum PostsRequests: FirestoreRequest {

    public typealias Fields = PostModel.Fields

    case postImage(userId: String, image: String)

    public var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .postImage(let userId, let image):
            params[Fields.Key.userId.rawValue] = userId
            params[Fields.Key.image.rawValue] = image
            params[Fields.Key.createdAt.rawValue] = Date()
            params[Fields.Key.updatedAt.rawValue] = Date()
            return params
        }
    }

}
