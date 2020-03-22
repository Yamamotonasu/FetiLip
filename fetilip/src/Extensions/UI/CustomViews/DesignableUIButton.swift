//
//  DesignableUIButton.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/22.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableUIButton: UIButton {

    /// 角丸の大きさ
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }

    /// 枠線の幅
    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }

    /// 枠線の色
    @IBInspectable var borderColor: UIColor {
        get {
            guard let cgColor = self.layer.borderColor else { return .clear }
            return UIColor(cgColor: cgColor)
        }
        set { self.layer.borderColor = newValue.cgColor }
    }

    /// 影の色
    @IBInspectable var shadowColor: UIColor? {
      get {
        return layer.shadowColor.map { UIColor(cgColor: $0) }
      }
      set {
        layer.shadowColor = newValue?.cgColor
        layer.masksToBounds = false
      }
    }

    /// 影の透明度
    @IBInspectable var shadowAlpha: Float {
      get {
        return layer.shadowOpacity
      }
      set {
        layer.shadowOpacity = newValue
      }
    }

    /// 影のオフセット
    @IBInspectable var shadowOffset: CGSize {
      get {
       return layer.shadowOffset
      }
      set {
        layer.shadowOffset = newValue
      }
    }

    /// 影のぼかし量
    @IBInspectable var shadowRadius: CGFloat {
      get {
       return layer.shadowRadius
      }
      set {
        layer.shadowRadius = newValue
      }
    }

    
}
