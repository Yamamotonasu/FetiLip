//
//  UserBlocksClientProtocol.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol UserBlockClientProtocol {
    
    func setUserBlocks(uid: String, targetUid: String) -> Single<()>

    func getUserBlocks(uid: String) -> Single<[UserBlockEntity]>
    
}

public struct UserBlockClient: UserBlockClientProtocol {
    
    public init () {}
    
    func setUserBlocks(uid: String, targetUid: String) -> Single<()> {
        let fields = UserBlockRequest.addBlock(targetUid: targetUid).parameters
        return Firestore.firestore().rx.addData(UserBlockModel.self, collectionRef: UserBlockModel.makeSubCollectionRef(parentCollection: UserModel.self, uid: uid), fields: fields)
    }

    func getUserBlocks(uid: String) -> Single<[UserBlockEntity]> {
        return Firestore.firestore().rx.getSubCollection(UserBlockModel.self, subCollectionQuery: UserBlockModel.makeSubCollectionRef(parentCollection: UserModel.self, uid: uid))
    }
    
}
