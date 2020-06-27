//
//  FirebaseUser+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseAuth

extension User {

    /// Custom error from firebase authentication.
    public enum AuthError: Error {
        case currentUserNotFound
        case failedLogout

        var message: String {
            switch self {
            case .currentUserNotFound:
                return "ユーザーが見つかりません。再度ログインしてください。"
            case .failedLogout:
                return "ログアウトに失敗しました。再度お試しください。"
            }
        }
    }

}
