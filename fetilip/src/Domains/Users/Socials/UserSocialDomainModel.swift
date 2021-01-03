//
//  UserSocialDomainModel.swift
//  
//
//  Created by 山本裕太 on 2020/09/13.
//

import Foundation

public struct UserSocialDomainModel: DomainModelProtocol {

    typealias Input = UserSocialEntity

    typealias Output = Self

    let fetiPoint: String

    let postCount: String

    static func convert(_ model: Input) -> Output {
        return self.init(fetiPoint: String(model.fetiPoint),
                         postCount: String(model.postCount))
    }

}
