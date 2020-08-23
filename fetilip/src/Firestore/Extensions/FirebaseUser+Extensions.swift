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

        case needToUpdateFromAnonymousUser

        case failedLogout

        case failedUpdateEmail(reason: String)

        var message: String {
            switch self {
            case .currentUserNotFound:
                return "ユーザーが見つかりません。再度ログインしてください。"
            case .failedLogout:
                return "ログアウトに失敗しました。再度お試しください。"
            case .needToUpdateFromAnonymousUser:
                return "正式な登録を行う必要があります。"
            case .failedUpdateEmail:
                return "メールアドレスの更新に失敗しました。時間を置いてからお試しください。"
            }
        }
    }

}
