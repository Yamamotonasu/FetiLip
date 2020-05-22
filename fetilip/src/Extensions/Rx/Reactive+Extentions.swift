//
//  Reactive+Extentions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/17.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {

    /// Bindable sink for `image` property.
    public var image: Binder<UIImage?> {
        return Binder(base) { imageView, image in
            imageView.image = image
        }
    }

}
