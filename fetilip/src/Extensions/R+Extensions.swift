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

        // MARK: - MainModal

        static let term = "利用規約"

        static let privacyPolicy = "プライバシーポリシー"

        static let termAndPrivacyPolicy = "\(term)、\(privacyPolicy)に同意する。"

        // MARK: - Title

        static let profileScreenTitle: String = "プロフィールを編集する"

        static let registerUserScreentTitle: String = "正式登録する"

        static let loginScreenTitle: String = "ログインする"

        static let editUserNameScreenTitle: String = "ユーザー名を更新する"

        static let editEmailScreenTitle: String = "メールアドレスを更新する"

        static let settingScreenTitle: String = "設定"

        // MARK: - Login

        static let doneLogin: String = "ログインしました"

        // MARK: - User message

        static let errorOccurred: String = "エラーが発生しました。時間を置いて再度お試しください。"

        static let requestUserLibraryPermission: String = "iPhoneの設定でFetilipから写真へのアクセスを許可してください"

        // MARK: - Firebase error message

        static let invalidEmail: String = "メールアドレスの形式が違います。正しい形式で入力してください。"

        static let weakPassword: String = "パスワードは6文字以上で入力してください。"

        static let emailAlreadyInUse: String = "このメールアドレスは既に使われています。別のアドレスを利用してください。"

        static let wrongPassword: String = "メールアドレス、またはパスワードが異なります。"

        static let userNotFound: String = "ユーザーが見つかりません。"

        static let internalError: String = "サーバーで問題が発生しています。\n管理者にお問い合わせ頂くか、時間を置いてお試しください。"

        static let userTokenExpired: String = "無効なセッションです。再ログインしてください。"

        static let userDisabled: String = "無効なアカウントです。"

        static let needRegitserUser: String = "レビューを投稿するには正式会員登録を行う必要があります。マイページ → プロフィール編集画面から登録出来ます。"

        // MARK: - UserDetail

        static let block = "ブロックする"

        struct error {

            // MARK: - PostLip

            static let imageNotFound = "画像が見つかりません。再度選択してください。"

            static let excessiveNumberOfInputs = "制限を超える文字数のレビューは投稿出来ません。"

            static let delete = "削除に失敗しました"

            // MARK: - EditProfile

            static let updateImageNotFound = "更新する画像が見つかりません。"

            // MARK: - Settings

            static let failedToStartMailer = "メーラーの起動に失敗しました"

            // MARK: - UserDetail

            static let block = "ブロックに失敗しました。時間を置いて再度お試しください。"

        }

        struct success {

            // MARK: - Common

            static let updateInformation = "情報を更新しました。"

            static let delete = "削除しました"

            // MARK: - PostLip
            static let postSucceed = "投稿しました！\nありがとうございます😃"

            static let reallyWantToDelete = "本当に投稿を削除しますか？"

            // MARK: - RegisterUser

            static let registerUserSuccess = "ユーザー登録をしました😃"

            // MARK: - EditProfile

            static let updateUserImageSuccess = "プロフィール画像を更新しました😃"

            // MARK: - Settings

            static let successSendMail = "お問い合わせありがとうございます。3営業日以内で返信致しますので、返信をお待ち下さい。"

            // MARK: - UserDetail

            static func block(targetUserName: String) -> String {
                return "\(targetUserName)さんをブロックしました。"
            }

        }

        struct validation {

            static let emptyInput: String = "入力してください。"

            static func tooLongInput(maximum: Int) -> String {
                return "入力出来るのは\(maximum)文字までです。"
            }

            // MARK: - Email

            static let invalidEmailFormat = "正しいメールアドレスを入力してください。"

            // MARK: - UserName

            static let emptyUserName: String = "ユーザー名が入力されていません。"

            static func tooShortName(minimum: Int) -> String {
                return "ユーザー名は\(minimum)文字以上にする必要があります。"
            }

            static func tooLongName(maximum: Int) -> String {
                return "ユーザー名は最大\(maximum)文字までです。"
            }

            // MARK: - Review

            static let reviewImageNotFound = "レビューを投稿するには画像が必要です。"

            static func tooLongReview(maximum: Int) -> String {
                return "レビューは最大\(maximum)文字までです。"
            }
        }

        struct view_message {

            // MARK: - Postlip

            static let editImage = "画像を編集する"

            static let selectImage = "画像を選択する"

            static let postTemplate = "使用した口紅: \n\n使用した感想:\n"
        }

        struct common {

            static let cancel = "キャンセル"

        }

    }

}
