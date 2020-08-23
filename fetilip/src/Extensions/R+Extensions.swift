//
//  R+Extended.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/27.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

extension R {

    struct _string {

        // MARK: - Title

        static let profileScreenTitle: String = "プロフィールを編集する"

        static let registerUserScreentTitle: String = "正式登録する"

        static let editUserNameScreenTitle: String = "ユーザー名を更新する"

        static let editEmailScreenTitle: String = "メールアドレスを更新する"

        // MARK: - User message

        static let errorOccurred: String = "エラーが発生しました。時間を置いて再度お試しください。"

        // MARK: - Firebase error message

        static let invalidEmail: String = "メールアドレスの形式が違います。正しい形式で入力してください。"

        static let weakPassword: String = "パスワードは6文字以上で入力してください。"

        static let emailAlreadyInUse: String = "このメールアドレスは既に使われています。別のアドレスを利用してください。"

        static let wrongPassword: String = "メールアドレス、またはパスワードが異なります。"

        static let userNotFound: String = "ユーザーが見つかりません。管理者にお問い合わせください。"

        static let internalError: String = "サーバーで問題が発生しています。\n管理者にお問い合わせ頂くか、時間を置いてお試しください。"

        static let userTokenExpired: String = "無効なセッションです。再ログインしてください。"

        static let userDisabled: String = "無効なアカウントです。"

        struct error {

            // MARK: - PostLip

            static let imageNotFound = "画像が見つかりません。再度選択してください。"

            static let excessiveNumberOfInputs = "制限を超える文字数のレビューは投稿出来ません。"

            // MARK: - EditProfile

            static let updateImageNotFound = "更新する画像が見つかりません。"
        }

        struct validation {

            static let emptyInput: String = "入力してください。"

            static func tooLongInput(maximum: Int) -> String {
                return "入力出来るのは\(maximum)文字までです。"
            }

            static let invalidEmailFormat = "正しいメールアドレスを入力してください。"

        }

    }

}
