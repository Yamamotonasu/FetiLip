//
//  IndicatorView.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

class IndicatorView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.backgroundColor = tintColor
    }

}
