//
//  DesignableUITextField.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/22.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableUITextField: UITextField {

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

    /// 上padding
    @IBInspectable var paddingTop: CGFloat = 0.0

    /// 右padding
    @IBInspectable var paddingRight: CGFloat = 0.0

    /// 左padding
    @IBInspectable var paddingBottom: CGFloat = 0.0

    /// 下padding
    @IBInspectable var paddingLeft: CGFloat = 0.0

    /// キャレットの色
    @IBInspectable var caretColor: UIColor = .systemBlue

    /// borderを付けるかどうか
    @IBInspectable var removeBorder: Bool = false

    /// 下線ボーダー色(border無しの時のみ有効)
    @IBInspectable var underLineColor: UIColor = .black

    /// 下線ボーダー高さ(border無しの時のみ有効)
    @IBInspectable var underLineBorderHeight: CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        // もしborderを外す時は下線borderの設定を行う
        if removeBorder {
            self.borderStyle = .none
            setupUnderLine()
        }
        self.tintColor = caretColor
        super.draw(rect)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        return bounds.inset(by: padding)
    }

}

// MARK: - Private functions

extension DesignableUITextField {

    /// 下線ボーダーをTextFieldへ追加する
    private func setupUnderLine() {
        let underLine = UIView()
        underLine.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: underLineBorderHeight)
        underLine.backgroundColor = underLineColor
        self.addSubview(underLine)
        self.bringSubviewToFront(underLine)
    }

}
