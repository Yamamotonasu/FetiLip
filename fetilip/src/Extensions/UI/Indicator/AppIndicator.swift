//
//  AppIndicator.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/05.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

/**
 * アプリ内で使用するNVActivityIndicatorViewの設定を纏めた構造体
 */
public struct AppIndicator {

    /// インジケータを設定
    public static func setupIndicator() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        NVActivityIndicatorView.DEFAULT_COLOR = FetiLipColors.theme()
        NVActivityIndicatorView.DEFAULT_PADDING = 10
    }

    /// インジケータを表示
    public static func show() {
        setupIndicator()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(), nil)
    }

    /// インジケータを非表示
    public static func dismiss() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }

}
