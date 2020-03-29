//
//  AppDelegate.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/15.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import XCGLogger

// MARK: XCGLogger

let log: XCGLogger = {
    let level: XCGLogger.Level = {
        // TODO: Releaseすると本番環境では.errorのみのログ出力にする事
        #if DEBUG
        return .verbose
        #else
        return .error
        #endif
    }()
    let log = XCGLogger.default
    log.setup(level: level,
              showLogIdentifier: true,
              showFunctionName: true,
              showThreadName: true,
              showLevel: true,
              showFileNames: true,
              showLineNumbers: true,
              showDate: true,
              writeToFile: nil,
              fileLevel: XCGLogger.Level.none)
    // TODO: logの色付き出力
    if let fileDestination: FileDestination = log.destination(withIdentifier: XCGLogger.Constants.fileDestinationIdentifier) as? FileDestination {
        let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
        ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
        ansiColorLogFormatter.colorize(level: .debug, with: .black)
        ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
        ansiColorLogFormatter.colorize(level: .notice, with: .green, options: [.italic])
        ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
        ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
        ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
        ansiColorLogFormatter.colorize(level: .alert, with: .white, on: .red, options: [.bold])
        ansiColorLogFormatter.colorize(level: .emergency, with: .white, on: .red, options: [.bold, .blink])
        fileDestination.formatters = [ansiColorLogFormatter]
        fileDestination.logQueue = XCGLogger.logQueue
        log.add(destination: fileDestination)
        log.logAppDetails()
        return log
    } else {
        return log
    }
}()

// MARK: AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// シングルトンオブジェクト化
    public static var shared: AppDelegate {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure()
            // AppDelegateのインスタンス化に失敗した時は強制終了させる
            exit(0)
        }
        return app
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = log
        // IQKeyBoardManagerの有効化
        IQKeyboardManager.shared.enable = true

        // 初期起動画面の設定(iOS13以下の時だけ初期化処理を行う)
        if #available(iOS 13, *) {
        } else {
            AppInitialization.settingStartScreen()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}
