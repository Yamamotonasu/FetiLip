//
//  ViolationReportsRequest.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/08.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

public enum ViolationReportsRequest: FirestoreRequest {

    public typealias Fields = ViolationReportModel.FieldType

    case sendViolationReport(targetUid: String, targetPostId: String, targetImageRef: String)

    public var parameters: Parameters {
        var params: Parameters = [:]
        switch self {
        case .sendViolationReport(let targetUid, let targetPostId, let targetImageRef):
            params[Fields.Key.targetUid.rawValue] = targetUid
            params[Fields.Key.targetPostId.rawValue] = targetPostId
            params[Fields.Key.targetImageRef.rawValue] = targetImageRef
            params[Fields.Key.createdAt.rawValue] = FieldValue.serverTimestamp()
            params[Fields.Key.updatedAt.rawValue] = FieldValue.serverTimestamp()
        }
        return params
    }

}
