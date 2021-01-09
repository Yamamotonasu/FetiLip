//
//  ViolationReportModel.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/08.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation

public struct ViolationReportModel: FirestoreDatabaseCollection {

    public typealias FieldType = ViolationReportEntity

    public static let collectionName: String = "violationReports"

    public let id: String

    public let fields: FieldType?

    public init(id: String, fields: FieldType?) {
        self.id = id
        self.fields = fields
    }

}
