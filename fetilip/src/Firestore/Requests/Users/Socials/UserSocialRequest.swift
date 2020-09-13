//
//  UserSocialRequest.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

enum UserSocialRequest: FirestoreRequest {

    typealias Fields = UserSocialModel.FieldType

    case inrementPost

    var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .inrementPost:
            params[Fields.Key.fetiPoint.rawValue] = FieldValue.increment(Int64(FetiPointCriteria.post.increasingValue))
            params[Fields.Key.postCount.rawValue] = FieldValue.increment(Int64(1))
            params[Fields.Key.updatedAt.rawValue] = FieldValue.serverTimestamp()
            return params
        }
    }

}
