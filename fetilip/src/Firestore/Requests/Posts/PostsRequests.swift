//
//  PostsRequests.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

public enum PostsRequests: FirestoreRequest {

    public typealias Fields = PostModel.Fields

    case postImage(userId: String, review: String, image: String, userRef: DocumentReference)

    public var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .postImage(let userId, let review, let image, let userRef):
            params[Fields.Key.userId.rawValue] = userId
            params[Fields.Key.review.rawValue] = review
            params[Fields.Key.image.rawValue] = image
            params[Fields.Key.userRef.rawValue] = userRef
            params[Fields.Key.createdAt.rawValue] = Date()
            params[Fields.Key.updatedAt.rawValue] = Date()
            return params
        }
    }

}
