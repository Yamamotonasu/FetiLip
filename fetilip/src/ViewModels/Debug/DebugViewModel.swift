//
//  DebugViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
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

    private let dismissRelay: PublishRelay<()> = PublishRelay<()>()

    private let loginInfoRelay: PublishRelay<String> = PublishRelay<String>()

    private let notifySubject: PublishSubject<String> = PublishSubject<String>()

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
            LoginAccountData.uid = user.uid
            self.setUserData(params: (email: user.email ?? "",
                                      uid: user.uid))
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
        authModel.logout().subscribe(onSuccess: {
            self.notifySubject.onNext("ログアウトしました。")
            self.checkLogined()
        }, onError: { e in
            log.error(e)
            self.notifySubject.onNext(e.localizedDescription)
        }).disposed(by: disposeBag)
    }

    /// Save users collection to default user
    private func setUserData(params: (email: String, uid: String)) {
        usersModelClient.setInitialData(params: params).subscribe(onSuccess: { _ in
            self.notifySubject.onNext("ユーザーを作成しました。")
        }, onError: { e in
            log.error(e)
            self.notifySubject.onNext("ユーザーの作成に失敗しました")
        }).disposed(by: disposeBag)
    }

    private func uploadImage(image: UIImage?) {
        guard let uploadImage = image?.jpegData(compressionQuality: 0.3) else { return }
        let imageReference = Storage.storage().reference().child("/productImages/lip.jpeg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageReference.putData(uploadImage, metadata: metaData) { _, error in
            if let e = error {
                self.notifySubject.onNext(e.localizedDescription)
                return
            }
            imageReference.downloadURL { url, error in
                if let e = error {
                    self.notifySubject.onNext(e.localizedDescription)
                }
                guard let uploadedImageUrl = url else {
                    return
                }
                let str = String(describing: uploadedImageUrl)
                self.uploadedImageUrlRelay.accept(str)
            }
        }
    }

    /// Commit user name
    private func commitUserName(with userName: String) {
        usersModelClient.updateUserName(userName: userName).subscribe(onSuccess: { _ in
            self.notifySubject.onNext("名前を更新しました。")
        }, onError: { e in
            log.error(e)
            self.notifySubject.onNext("名前の更新に失敗しました。")
        }).disposed(by: disposeBag)
    }

    /// Commit user profile.
    private func commitUserProfile(with userProfile: String) {
        usersModelClient.updateUserProfile(profile: userProfile).subscribe(onSuccess: { _ in
            self.notifySubject.onNext("プロフィールを更新しました。")
        }, onError: { e in
            log.error(e)
            self.notifySubject.onNext("プロフィールの更新に失敗しました。")
        }).disposed(by: disposeBag)
    }

}

// MARK: I/O

extension DebugViewModel: ViewModelType {

    public struct Input {
        let userNameObservable: Observable<String>
        let userProfileObservable: Observable<String>
        let updaloadImageViewObservable: Observable<UIImage?>
        let tapBackButton: Signal<Void>
        let tapLoginButton: Signal<Void>
        let tapLogoutButton: Signal<Void>
        let tapUploadImageButton: Observable<Void>
        let tapSaveNameButton: Observable<Void>
        let tapSaveProfileButton: Observable<Void>
    }

    public struct Output {
        let dismissEvent: Signal<()>
        let loginInfoDriver: Driver<String>
        let notifyObservable: Observable<String>
        let loginStateDriver: Driver<Bool>
        let uploadedImageUrlDriver: Driver<String>
    }

    public func transform(input: Input) -> Output {
        // Reaction to the dismiss event.
        input.tapBackButton.emit(to: dismissRelay).disposed(by: disposeBag)

        // Reaction to the tap of the login button.
        input.tapLoginButton.emit(onNext: { _ in
            self.anonymousLogin()
        }).disposed(by: disposeBag)

        // Reaction to the tap of the logout button.
        input.tapLogoutButton.emit(onNext: { _ in
            self.logout()
        }).disposed(by: disposeBag)

        // Reaction to the tap of the upload image button.
        input.tapUploadImageButton.withLatestFrom(input.updaloadImageViewObservable).subscribe(onNext: { image in
            self.uploadImage(image: image)
        }).disposed(by: disposeBag)

        // Reaction to the tap of the save user name button.
        input.tapSaveNameButton.withLatestFrom(input.userNameObservable).subscribe(onNext: { userName in
            self.commitUserName(with: userName)
        }).disposed(by: disposeBag)

        // Reaction to the tap of the save user profile button.
        input.tapSaveProfileButton.withLatestFrom(input.userProfileObservable).subscribe(onNext: { profile in
            self.commitUserProfile(with: profile)
        }).disposed(by: disposeBag)

        return  Output(dismissEvent: dismissRelay.asSignal(),
                       loginInfoDriver: loginInfoRelay.asDriver(onErrorJustReturn: ""),
                       notifyObservable: notifySubject.asObservable(),
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
