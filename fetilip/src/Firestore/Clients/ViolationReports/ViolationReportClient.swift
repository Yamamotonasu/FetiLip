//
//  ViolationReportClient.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/08.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

protocol ViolationReportClientProtocol {

    func sendViolationReport() -> Single<()>

}

struct ViolationReportClient: ViolationReportClientProtocol {

    func sendViolationReport() -> Single<()> {
        return Single.create { observer in
            return Disposables.create()
        }
    }

}
