//
//  AppAlert.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import SwiftMessages

/**
 * App default alert struct.
 */
public struct AppAlert {

    /**
     * Show app default alert.
     *
     * - Parameters:
     *  - view: MessageView
     *  - message: Display message on alert.
     *  - alertType: Display alert type.
     *  - complection: Completion handler invoke did hide.
     */
    static func show(view: MessageView = MessageView.viewFromNib(layout: .messageView), message: String, alertType: AlertType, completion: (() -> Void)? = nil) {
        // region - Config
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = .seconds(seconds: 3.0)

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
