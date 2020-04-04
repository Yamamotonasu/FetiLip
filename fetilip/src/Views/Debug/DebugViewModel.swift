//
//  DebugViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * DebugViewModelのProtocol
 */
protocol DebugViewModelProtocol {

    func anonymousLogin()

}

struct DebugViewModel: DebugViewModelProtocol {

    /// 匿名ログインを実行する
    func anonymousLogin() {
//        Auth.auth().signInAnonymously { (result, error) in
//
//        }
    }

}
