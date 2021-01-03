//
//  UIFont+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/24.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    convenience init?(name: CustomFonts, size: CGFloat) {
        self.init(name: name.rawValue, size: size)
    }

}

public enum CustomFonts: String {

    case sourceHanSansExtraLight = "SourceHanSans-ExtraLight"

    case sourceHanSansLight = "SourceHanSans-Light"

    case sourceHanSansMedium = "SourceHanSans-Medium"

    case sourceHanSansNormal = "SourceHanSans-Normal"

    case sourceHanSansRegular = "SourceHanSans-Regular"

    case sourceHanSansBold = "SourceHanSans-Bold"

    case sourceHanSansHeavy = "SourceHanSans-Heavy"

    case yuGothicBold = "YuGo-Bold"

    case yuGothicRegular = "YuGo-Medium"

}
