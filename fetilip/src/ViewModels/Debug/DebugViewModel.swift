//
//  DebugViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
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

    init(model: UserAuthModelProtocol) {
        self.loginInfoDriver = loginInfoRelay.asDriver(onErrorJustReturn: "")
        self.errorObservable = errorSubject.asObservable()
        self.loginStateDriver = loginStateRelay.asDriver(onErrorJustReturn: false)
        self.uploadedImageUrlDriver = uploadedImageUrlRelay.asDriver(onErrorJustReturn: "")
        self.authModel = model
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

    /// User authentication model.
    private let authModel: UserAuthModelProtocol

    /// Communication with firestore users collection model.
    private let usersModelClient: UsersModelClient = UsersModelClient()

}

extension DebugViewModel {

    /// Create user and login.
    public func anonymousLogin() {
        // Return if already logged in.
        let _ = authModel.createAnonymousUser().subscribe(onSuccess: {
            user in
            self.drawUserInfo(with: user)
            self.loginStateRelay.accept(true)
            // TODO: UserDefaults
            let u = UserModel(id: user.uid)
            // FireStore動作確認の為とりあえず雑にデータ保存を実装
            let userData: [String: Any] = [
                "email": user.email ?? "",
                "userName": user.displayName ?? "",
                "phoneNumber": user.phoneNumber ?? "",
                "createdAt": Timestamp(date: Date())
            ]
            self.setUserData(user: u, fields: userData)
        })

    }

    /// Confirming login state.
    public func checkLogined() {
        let _ = authModel.checkLogin().subscribe(onSuccess: { user in
            self.drawUserInfo(with: user)
            self.loginStateRelay.accept(true)
        }, onError: { _ in
            self.loginInfoRelay.accept("ログイン時にはここにログインユーザーの情報が表示されます。")
            self.loginStateRelay.accept(false)
        })
    }

    /// Log out with auth model.
    public func logout() {
        let _ = authModel.logout().subscribe(onSuccess: {
            self.errorSubject.onNext("ログアウトしました。")
            self.checkLogined()
        }, onError: { e in
            self.errorSubject.onNext(e.localizedDescription)
        })
    }

    /// Save users collection to default user
    private func setUserData(user: UserModel, fields: [String: Any]) {
        let _ = usersModelClient.setData(user, documentRef: user.makeDocumentRef(), fields: fields).subscribe(onSuccess: { _ in
            self.errorSubject.onNext("ユーザーを作成しました")
        }, onError: { e in
            self.errorSubject.onNext(e.localizedDescription)
        })
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
    private func drawUserInfo(with user: FirebaseUser) {
        loginInfoRelay.accept("メールアドレス: \(user.email ?? "未登録")\nユーザー名: \(user.displayName ?? "未登録")\n電話番号: \(user.phoneNumber ?? "未登録")\nuid: \(user.uid)\nプロバイダID: \(user.providerID)")
    }

}
