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

protocol UserBlocksProtocol {
    
    func setUserBlocks(uid: String, targetUid: String) -> Single<()>
    
}

public struct UserBlocksClient {
    
    func setUserBlocks(uid: String, targetUid: String) -> Single<()> {
        let fields = UserBlockRequest.addBlock(targetUid: targetUid).parameters
        return Firestore.firestore().rx.addData(UserBlockModel.self, collectionRef: UserBlockModel.makeSubCollectionRef(parentCollection: UserModel.self, uid: uid), fields: fields)
    }
    
}
