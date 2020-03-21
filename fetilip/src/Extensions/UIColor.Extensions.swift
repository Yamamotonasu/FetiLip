//
//  UIColor.Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension UIColor: ExtensionCompatible {}

extension Extension where Base: UIColor{

    public static func hex(_ hexStr: String, alpha: CGFloat) -> UIColor {
        let alpha = alpha
        var hexStr = hexStr
        hexStr = (hexStr.replacingOccurrences(of: "#", with: "") as NSString) as String
        let scanner = Scanner(string: hexStr as String)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        } else {
            return UIColor.white
        }
    }

}
