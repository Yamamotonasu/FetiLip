//
//  CGPoint+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint: ExtensionCompatible {}

extension Extension where Base == CGPoint {

    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.base.x - point.x, self.base.y - point.y)
    }

}
