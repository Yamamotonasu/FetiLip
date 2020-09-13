//
//  UserSocialClient.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol UserSocialClientProtocol {

    /**
     * Increment value in social collection data.
     *
     * - Parameters:
     *  - uid: UID
     * - Returns: Single<()>
     */
    func incrementPost(uid: String) -> Single<()>

    /**
     * Get social data.
     *
     * - Parameters:
     *  - uid: UID
     * - Returns: SIngle<UserSocialEntity>
     */
    func getUserSocial(uid: String) -> Single<UserSocialEntity>

}

struct UserSocialClient: UserSocialClientProtocol {

    public init() {}

    public func incrementPost(uid: String) -> Single<()> {
        let fields = UserSocialRequest.inrementPost.parameters
        return Firestore.firestore().rx.updateData(UserSocialModel.self, documentRef: UserSocialModel.makeDocumentRef(id: uid), fields: fields)
    }

    public func getUserSocial(uid: String) -> Single<UserSocialEntity> {
        return Firestore.firestore().rx.getDocument(UserSocialModel.self, documentReference: UserSocialModel.makeDocumentRef(id: uid))
    }

}
