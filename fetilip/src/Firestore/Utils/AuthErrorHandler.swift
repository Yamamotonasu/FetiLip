//
//  AuthErrorHandler.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/27.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseAuth

/**
 * Auth error handler class.
 */
public struct AuthErrorHandler {

    static func errorCode(_ error: Error) -> AuthErrorCode {
        if let e = AuthErrorCode(rawValue: error._code) {
            return e
        } else {
            return AuthErrorCode.appNotAuthorized
        }
    }

    static func errorMessage(_ error: Error) -> String {
        if let e = AuthErrorCode(rawValue: error._code) {
            switch e {
            case .invalidEmail:
                return "メールアドレスの形式が違います。正しい形式で入力してください。"
            case .weakPassword:
                return "パスワードは6文字以上で入力してください。"
            case .emailAlreadyInUse:
                return "このメールアドレスは既に使われています。別のアドレスを利用してください。"
            case .wrongPassword:
                return "メールアドレス、またはパスワードが異なります。"
            case .userNotFound:
                return "ユーザーが見つかりません。管理者にお問い合わせください。"
            case .internalError:
                return "サーバーで問題が発生しています。\n管理者にお問い合わせ頂くか、時間を置いてお試しください。"
            case .userTokenExpired:
                return "無効なセッションです。再ログインしてください。"
            case .userDisabled:
                return "無効なアカウントです。"
            default:
                return "エラーが発生しました。時間を置いて再度お試しください。"
            }
        } else {
            return "エラーが発生しました。時間を置いて再度お試しください。"
        }
    }

 }
