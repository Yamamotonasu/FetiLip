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
 * DebugViewControllerに対応するViewModel
 */
struct DebugViewModel {

    /// DI init.
    init(dependency: ((usersModelClient: UsersModelClient,
        authModel: UserAuthModelProtocol))) {
        usersModelClient = dependency.usersModelClient
        authModel = dependency.authModel
    }

    /// User authentication model.
    private let authModel: UserAuthModelProtocol

    /// Communication with firestore users collection model.
    private let usersModelClient: UsersModelClient

    // MARK: - Rx

    private let disposeBag = DisposeBag()

    private let dismissRelay: BehaviorRelay<()> = BehaviorRelay<()>(value: ())

    private let loginInfoRelay: PublishRelay<String> = PublishRelay<String>()

    private let errorSubject: PublishSubject<String> = PublishSubject<String>()

    private let loginStateRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    private let uploadedImageUrlRelay: PublishRelay<String> = PublishRelay<String>()

}

extension DebugViewModel {

    /// Create user and login.
    public func anonymousLogin() {
        // Return if already logged in.
        authModel.createAnonymousUser().subscribe(onSuccess: {
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
        }).disposed(by: disposeBag)

    }

    /// Confirming login state.
    public func checkLogined() {
        authModel.checkLogin().subscribe(onSuccess: { user in
            self.drawUserInfo(with: user)
            self.loginStateRelay.accept(true)
        }, onError: { _ in
            self.loginInfoRelay.accept("ログイン時にはここにログインユーザーの情報が表示されます。")
            self.loginStateRelay.accept(false)
            }).disposed(by: disposeBag)
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

// MARK: I/O

extension DebugViewModel: ViewModelType {

    public struct Input {
        let userNameObservable: Observable<String>
        let userProfileObservable: Observable<String>
        let updaloadImageViewObservable: Observable<UIImage?>
        let tapLoginButton: Observable<Void>
        let tapLogoutButton: Observable<Void>
        let tapUploadImageButton: Observable<Void>
        let tapSaveNameButton: Observable<Void>
        let tapSaveProfileButton: Observable<Void>
    }

    public struct Output {
        let loginInfoDriver: Driver<String>
        let errorObservable: Observable<String>
        let loginStateDriver: Driver<Bool>
        let uploadedImageUrlDriver: Driver<String>
    }

    public func transform(input: Input) -> Output {
        // Reaction to the tap of the login button.
        input.tapLoginButton.subscribe(onNext: { _ in
            self.anonymousLogin()
        }).disposed(by: disposeBag)

        // Reaction to the tap of the logout button.
        input.tapLogoutButton.subscribe(onNext: { _ in
            self.logout()
        }).disposed(by: disposeBag)

        // Reaction to the tap of the upload image button.
        input.tapUploadImageButton.withLatestFrom(input.updaloadImageViewObservable).subscribe(onNext: { image in
            self.uploadImage(image: image)
        }).disposed(by: disposeBag)

        return  Output(loginInfoDriver: loginInfoRelay.asDriver(onErrorJustReturn: ""),
                       errorObservable: errorSubject.asObservable(),
                       loginStateDriver: loginStateRelay.asDriver(onErrorJustReturn: false),
                       uploadedImageUrlDriver: uploadedImageUrlRelay.asDriver(onErrorJustReturn: ""))

    }

}

// MARK: Private functions

extension DebugViewModel {

    /// ユーザー情報をLabelに描画する
    private func drawUserInfo(with user: FirebaseUser) {
        loginInfoRelay.accept("メールアドレス: \(user.email ?? "未登録")\nユーザー名: \(user.displayName ?? "未登録")\n電話番号: \(user.phoneNumber ?? "未登録")\nuid: \(user.uid)\nプロバイダID: \(user.providerID)")
    }

}

extension Reactive where Base: Firestore {
public func setData<T: FirestoreDatabaseCollection>(_ type: T.Type,
                                           documentRef: DocumentReference,
                                           fields: [String: Any]) -> Single<()> {
    return Single.create { observer in
        documentRef
            .setData(fields) { error in
                if let error = error {
                    log.error(error)
                    observer(.error(error))
                } else {
                    observer(.success(()))
                }
        }
        return Disposables.create()
    }
    }
}
