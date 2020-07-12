//
//  AppInitialization.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/28.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

/**
 * アプリの初期起動画面制御等を纏めた構造体
 *  TODO: deeplink等もここで処理をこ行いたい
 */
public struct AppInitialization {

    /// アプリ起動後の画面をログイン状態によって振り分ける
    public static func settingStartScreen() {
    let tab = GlobalTabBarControllerGenerator.generate()
        let app = AppDelegate.shared

        // もしViewControllerのインスタンスが生成されていない時はUIWindowを初期化する
        if app.window == nil {
            app.window = UIWindow(frame: UIScreen.main.bounds)
        }
        app.window?.makeKeyAndVisible()
        // タブ画面を初期画面に設定
        app.window?.rootViewController = tab
    }

}
