//
//  UICollectionView+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension NSObjectProtocol {

    // クラス名を返す変数"className"を返す
    static var className: String {
        return String(describing: self)
    }

}

extension UICollectionReusableView {

    static var identifier: String {
        return className
    }

}

extension UICollectionView {

    func registerCustomCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellWithReuseIdentifier: T.identifier)
    }

    func dequeueReusableCustomCell<T: UICollectionReusableView>(_ viewType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

}
