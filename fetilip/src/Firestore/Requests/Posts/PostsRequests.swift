//
//  PostsRequests.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

public enum PostsRequests: FirestoreRequest {

    public typealias Fields = PostModel.FieldType

    case postImage(review: String, userRef: DocumentReference, userUid: String, imageRef: String)

    public var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .postImage(let review, let userRef, let userUid, let imageRef):
            params[Fields.Key.review.rawValue] = review
            params[Fields.Key.userRef.rawValue] = userRef
            params[Fields.Key.userUid.rawValue] = userUid
            params[Fields.Key.imageRef.rawValue] = imageRef
            params[Fields.Key.createdAt.rawValue] = FieldValue.serverTimestamp()
            params[Fields.Key.updatedAt.rawValue] = FieldValue.serverTimestamp()
            return params
        }
    }

}
