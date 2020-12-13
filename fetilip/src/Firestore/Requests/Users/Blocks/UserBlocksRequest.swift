//
//  UserBlocksRequest.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

enum UserBlockRequest: FirestoreRequest {

    typealias Fields = UserBlockModel.FieldType

    case addBlock(targetUid: String)

    var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .addBlock(let targetUid):
            params[Fields.Key.targetUid.rawValue] = targetUid
            params[Fields.Key.createdAt.rawValue] = FieldValue.serverTimestamp()
            params[Fields.Key.updatedAt.rawValue] = FieldValue.serverTimestamp()
            return params
        }
    }

}
