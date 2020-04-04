//
//  DebugViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import RxSwift
import RxCocoa

/**
 * DebugViewModelのProtocol
 */
protocol DebugViewModelProtocol {

    func checkLogined()

    func anonymousLogin()

    func logout()

    func uploadImage(image: UIImage?)

    var loginInfoDriver: Driver<String> { get }

    var errorObservable: Observable<String> { get }

    var loginStateDriver: Driver<Bool> { get }

    var uploadedImageUrlDriver: Driver<String> { get }

}

/**
 * DebugViewControllerに対応するViewModel
 */
struct DebugViewModel: DebugViewModelProtocol {

    init() {
        loginInfoDriver = loginInfoRelay.asDriver(onErrorJustReturn: "")
        errorObservable = errorSubject.asObservable()
        loginStateDriver = loginStateRelay.asDriver(onErrorJustReturn: false)
        uploadedImageUrlDriver = uploadedImageUrlRelay.asDriver(onErrorJustReturn: "")
    }

    /// エラーアラート通知用Subject
    private let errorSubject: PublishSubject<String> = PublishSubject<String>()

    /// ログイン情報描画用Relay
    private let loginInfoRelay: PublishRelay<String> = PublishRelay<String>()

    /// ログイン状態通知用Relay
    private let loginStateRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    /// アップロードした画像URL表示用
    private let uploadedImageUrlRelay: PublishRelay<String> = PublishRelay<String>()

    /// ログイン情報描画用Driver
    private(set) var loginInfoDriver: Driver<String>

    /// エラーアラート通知用Observable
    private(set) var errorObservable: Observable<String>

    /// ログインしているかどうかのDriver
    private(set) var loginStateDriver: Driver<Bool>

    /// アップロードした画像URL表示用
    private(set) var uploadedImageUrlDriver: Driver<String>

}

extension DebugViewModel {

    /// 匿名ユーザー作成/ログインを実行する
    public func anonymousLogin() {
        // すでにログイン中の場合はreturnする
        if let user = Auth.auth().currentUser {
            self.errorSubject.onNext("すでにログインしています。")
            self.drawUserInfo(with: user)
            self.loginStateRelay.accept(true)
        }
        // TODO: モデル化
        Auth.auth().signInAnonymously { (result, error) in
            if let e = error {
                // TODO: AuthErrorsを日本語に変換する為のクラス作成
                self.errorSubject.onNext(e.localizedDescription)
            }
            // ユーザー作成失敗時
            guard let _ = result?.user else {
                self.errorSubject.onNext("ユーザーの作成に失敗しました。")
                self.loginStateRelay.accept(false)
                return
            }
            if let user = Auth.auth().currentUser {
                self.drawUserInfo(with: user)
                self.loginStateRelay.accept(true)
                // FireStore動作確認の為とりあえず雑にデータ保存を実装
                let userData: [String: Any] = [
                    "email": user.email ?? "",
                    "userName": user.displayName ?? "",
                    "phoneNumber": user.phoneNumber ?? "",
                    "createdAt": Timestamp(date: Date())
                ]
                // データを保存(uidをdocumentに設定)
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    if let e = error {
                        self.errorSubject.onNext(e.localizedDescription)
                    } else {
                        self.errorSubject.onNext("ユーザーを作成しました")
                    }
                }
            }
        }
    }

    /// ログイン状態を確認する
    public func checkLogined() {
        if let user = Auth.auth().currentUser {
            self.drawUserInfo(with: user)
            loginStateRelay.accept(true)
        } else {
            loginInfoRelay.accept("ログイン時にはここにログインユーザーの情報が表示されます。")
            loginStateRelay.accept(false)
        }
    }

    public func logout() {
        do {
            try Auth.auth().signOut()
            self.errorSubject.onNext("ログアウトしました。")
            checkLogined()
        } catch let e {
            self.errorSubject.onNext(e.localizedDescription)
        }
    }

    public func uploadImage(image: UIImage?) {
        guard let uploadImage = image?.jpegData(compressionQuality: 0.3) else { return }
        let imageReference = Storage.storage().reference().child("/productImages/lip.jpeg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageReference.putData(uploadImage, metadata: metaData) { _, error in
            if let e = error {
                self.errorSubject.onNext(e.localizedDescription)
                return
            }
            imageReference.downloadURL { url, error in
                if let e = error {
                    self.errorSubject.onNext(e.localizedDescription)
                }
                guard let uploadedImageUrl = url else {
                    return
                }
                let str = String(describing: uploadedImageUrl)
                self.uploadedImageUrlRelay.accept(str)
            }
        }
    }

}

// MARK: Private functions

extension DebugViewModel {

    /// ユーザー情報をLabelに描画する
    private func drawUserInfo(with user: User) {
        loginInfoRelay.accept("メールアドレス: \(user.email ?? "未登録")\nユーザー名: \(user.displayName ?? "未登録")\n電話番号: \(user.phoneNumber ?? "未登録")\nuid: \(user.uid)\nプロバイダID: \(user.providerID)")
    }

}
