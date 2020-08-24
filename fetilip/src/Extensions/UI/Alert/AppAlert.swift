//
//  AppAlert.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import SwiftMessages

public struct AppAlert {

    /**
     * Show alert.
     */
    static func show(view: MessageView = MessageView.viewFromNib(layout: .messageView)) {
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = .seconds(seconds: 3.0)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        view.backgroundColor = .black
        view.configureContent(title: "",body: "テストテストテスト", iconText: "😊")
        SwiftMessages.show(config: config, view: view)
    }

}

public enum AlertType {

    case error

    case success

    case info

}

private extension String {

    func attachDefaultFont(size: CGFloat = 15, color: UIColor = .white) {
        let attributes = [ NSAttributedString.Key.foregroundColor: color,
                           NSAttributedString.Key.font: UIFont()]
    }

}
