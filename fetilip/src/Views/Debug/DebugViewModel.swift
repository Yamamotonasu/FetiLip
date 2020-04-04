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

    var loginInfoDriver: Driver<String> { get }

    var errorObservable: Observable<String> { get }

}

/**
 * DebugViewControllerに対応するViewModel
 */
struct DebugViewModel: DebugViewModelProtocol {

    init() {
        loginInfoDriver = loginInfoRelay.asDriver(onErrorJustReturn: "")
        errorObservable = errorSubject.asObservable()
    }

    /// エラーアラート通知用Subject
    private let errorSubject: PublishSubject<String> = PublishSubject<String>()

    /// ログイン情報描画用Relay
    private let loginInfoRelay: PublishRelay<String> = PublishRelay<String>()

    /// ログイン情報描画用Driver
    private(set) var loginInfoDriver: Driver<String>

    /// エラーアラート通知用Observable
    private(set) var errorObservable: Observable<String>

}

extension DebugViewModel {


    /// 匿名ログインを実行する
    public func anonymousLogin() {
        // すでにログイン中の場合はreturnする
        if let user = Auth.auth().currentUser {
            self.errorSubject.onNext("すでにログインしています。")
            self.drawUserInfo(with: user)
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
                return
            }
            if let user = Auth.auth().currentUser {
                self.drawUserInfo(with: user)
            }
        }
    }

    public func checkLogined() {
        if let user = Auth.auth().currentUser {
            self.drawUserInfo(with: user)
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
