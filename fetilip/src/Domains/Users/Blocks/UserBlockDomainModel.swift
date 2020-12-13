//
//  UserBlockDomainModel.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

public struct UserBlockDomainModel: DomainModelProtocol {

    typealias Input = UserBlockEntity

    typealias Output = Self

    let targetUid: String

    let createdAt: Timestamp

    let updatedAt: Timestamp

    static func convert(_ model: UserBlockEntity) -> UserBlockDomainModel {
        return self.init(targetUid: model.targetUid,
                         createdAt: model.createdAt,
                         updatedAt: model.updatedAt)
    }

}
