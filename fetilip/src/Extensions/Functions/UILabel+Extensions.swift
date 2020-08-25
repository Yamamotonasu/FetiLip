//
//  UILabel+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    func attachDefaultFont(size: CGFloat = 17, color: UIColor = .white, text: String) {
        let attributes = [ NSAttributedString.Key.foregroundColor: color,
                           NSAttributedString.Key.font: UIFont(name: .sourceHanSansNormal, size: size)!]
        let attributeString = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributeString
    }

}
