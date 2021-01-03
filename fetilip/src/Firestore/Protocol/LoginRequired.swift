//
//  LoginRequired.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

public protocol RequiredLogin {}

extension RequiredLogin {

    func getUserId() -> Single<String> {
        return Single.create { observer in
            guard let uid = LoginAccountData.uid else {
                observer(.error(FirebaseUser.AuthError.currentUserNotFound))
                return Disposables.create()
            }
            observer(.success(uid))
            return Disposables.create()
        }
    }
}
