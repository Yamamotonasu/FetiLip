//
//  AppAlert.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
import RxSwift

/**
 * App default alert struct.
 */
public struct AppAlert {

    /**
     * Show app default alert.
     *
     * - Parameters:
     *  - view: MessageView
     *  - duration: Display alert seconds.
     *  - message: Display message on alert.
     *  - alertType: Display alert type.
     *  - complection: Completion handler invoke did hide.
     */
    static func show(view: MessageView = MessageView.viewFromNib(layout: .messageView),
                     duration: SwiftMessages.Duration = .seconds(seconds: 3.0),
                     message: String,
                     alertType: AlertType,
                     completion: (() -> Void)? = nil) {
        // region - Config
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = duration

        config.eventListeners.append() { event in
            if case .didHide = event { if let c = completion { c() } }
        }

        // region - view
        view.configureDropShadow()
        view.button?.isHidden = true
        view.bodyLabel?.attachDefaultFont(text: message)
        view.titleLabel?.isHidden = true
        view.iconLabel?.attachDefaultFont(size: 15, text: alertType.icon)
        view.iconImageView?.isHidden = true
        view.backgroundColor = alertType.backgroundColor

        // Show alert 🎉
        SwiftMessages.show(config: config, view: view)
    }

    /**
     * Show app default alert.
     *
     * - Parameters:
     *  - view: MessageView (Arbitrary)
     *  - duration: Display alert seconds. (Arbitrary)
     *  - message: Display message on alert.
     *  - buttonTitle: Display button title. if you don't want to display the butto, use simple show function.
     *  - alertType: Display alert type.
     *  - buttonAction: Button action closure. (Arbitrary)
     *  - complection: Completion handler invoke did hide. (Arbitrary)
     */
    static func showWithButton(view: MessageView = MessageView.viewFromNib(layout: .messageView),
                               duration: SwiftMessages.Duration = .seconds(seconds: 3.0),
                               message: String,
                               buttonTitle: String,
                               alertType: AlertType,
                               buttonAction: ((UIButton?) -> Void)? = nil,
                               completion:(() -> Void)? = nil) {
        // region - Config
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = duration

        config.eventListeners.append() { event in
            if case .didHide = event { if let c = completion { c() } }
        }

        // region - view
        view.configureDropShadow()
        view.bodyLabel?.attachDefaultFont(text: message)
        view.titleLabel?.isHidden = true
        view.iconLabel?.attachDefaultFont(size: 15, text: alertType.icon)
        view.iconImageView?.isHidden = true

        // setup button
        view.button?.setTitle(buttonTitle, for: .normal)
        view.button?.tintColor = UIColor.white
        view.button?.titleLabel?.font = R.font.sourceHanSansMedium(size: 15)
        view.buttonTapHandler = buttonAction

        view.backgroundColor = alertType.backgroundColor

        SwiftMessages.show(config: config, view: view)
    }

    static func dismiss() {
        SwiftMessages.hide()
    }

    /**
     * When an error comes from stream, alert an retry.
     *
     * - Parameters:
     *  - error: Enum conform Error type.
     */
    static func errorObservable(_ error: Error) -> Observable<()> {
        return Observable.create { observer in
            Self.show(message: error.localizedDescription, alertType: .error)
            observer.on(.next(()))
            return Disposables.create()
        }
    }

}

/**
 * Enum alert type.
 */
public enum AlertType {

    case error

    case success

    case info

    var backgroundColor: UIColor {
        switch self {
        case .info:
            return FetiLipColors.theme()
        case .error:
            return FetiLipColors.error()
        case .success:
            return FetiLipColors.success()
        }
    }

    var icon: String {
        switch self {
        case .info:
            return "😊"
        case .error:
            return "😣"
        case .success:
            return "🎉"
        }
    }

}
