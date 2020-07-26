//
//  Binder+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/24.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NVActivityIndicatorView

extension Reactive where Base: NVActivityIndicatorView {

    // TODO: Confirm working
    var isAnimating: Binder<Bool> {
        return Binder(self.base) { indicator, flag in
            if flag {
                indicator.isHidden = false
                indicator.startAnimating()
            } else {
                indicator.isHidden = true
                indicator.stopAnimating()
            }
        }
    }

}
