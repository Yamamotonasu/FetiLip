//
//  ViolationReportClient.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/08.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol ViolationReportClientProtocol {

    func sendViolationReport(targetUid: String, targetPostId: String, targetImageRef: String) -> Single<()>

}

struct ViolationReportClient: ViolationReportClientProtocol {

    func sendViolationReport(targetUid: String, targetPostId: String, targetImageRef: String) -> Single<()> {
        let fields = ViolationReportsRequest.sendViolationReport(targetUid: targetUid, targetPostId: targetPostId, targetImageRef: targetImageRef).parameters
        return Firestore.firestore().rx.addData(ViolationReportModel.self, collectionRef: ViolationReportModel.makeCollectionRef(), fields: fields)
    }

}
