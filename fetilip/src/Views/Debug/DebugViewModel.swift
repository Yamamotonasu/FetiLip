//
//  DebugViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

/**
 * DebugViewModelのProtocol
 */
protocol DebugViewModelProtocol {

    func checkLogined()

    func anonymousLogin()

    func logout()

    var loginInfoDriver: Driver<String> { get }

    var errorObservable: Observable<String> { get }

    var loginStateDriver: Driver<Bool> { get }

}

/**
 * DebugViewControllerに対応するViewModel
 */
struct DebugViewModel: DebugViewModelProtocol {

    init() {
        loginInfoDriver = loginInfoRelay.asDriver(onErrorJustReturn: "")
        errorObservable = errorSubject.asObservable()
        loginStateDriver = loginStateRelay.asDriver(onErrorJustReturn: false)
    }

    /// エラーアラート通知用Subject
    private let errorSubject: PublishSubject<String> = PublishSubject<String>()

    /// ログイン情報描画用Relay
    private let loginInfoRelay: PublishRelay<String> = PublishRelay<String>()

    /// ログイン状態通知用Relay
    private let loginStateRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    /// ログイン情報描画用Driver
    private(set) var loginInfoDriver: Driver<String>

    /// エラーアラート通知用Observable
    private(set) var errorObservable: Observable<String>

    /// ログインしているかどうかのDriver
    private(set) var loginStateDriver: Driver<Bool>

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

}

// MARK: Private functions

extension DebugViewModel {

    /// ユーザー情報をLabelに描画する
    private func drawUserInfo(with user: User) {
        loginInfoRelay.accept("メールアドレス: \(user.email ?? "未登録")\nユーザー名: \(user.displayName ?? "未登録")\n電話番号: \(user.phoneNumber ?? "未登録")\nuid: \(user.uid)\nプロバイダID: \(user.providerID)")
    }

}
