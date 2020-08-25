//
//  FetiLipColors.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

/**
 * Project内で共通利用するUIColorを簡単に取得出来るようにしたクラス
 */
public struct FetiLipColors {

    /// テーマカラー
    static func theme(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.ex.hex("#FFA865", alpha: alpha)
    }

    /// 背景色
    static func background(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.ex.hex("#FFFFEF", alpha: alpha)
    }

    /// 文字色
    static func word(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.ex.hex("#030303", alpha: alpha)
    }

    /// エラー色
    static func error(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.ex.hex("#FFB4A8", alpha: alpha)
    }

    /// 成功
    static func success(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.ex.hex("#3AB483", alpha: alpha)
    }

}
