//
//  ExtensionCompatible.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

// 参考: https://qiita.com/motokiee/items/e8f07c11b88d692b2cc5

import Foundation

public struct Extension<Base> {
    let base: Base
    init (_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionCompatible {
    associatedtype Compatible
    static var ex: Extension<Compatible>.Type { get }
    var ex: Extension<Compatible> { get }
}

extension ExtensionCompatible {
    public static var ex: Extension<Self>.Type {
        return Extension<Self>.self
    }

    public var ex: Extension<Self> {
        return Extension(self)
    }

}

// MARK: For creating extend of array and collection

public protocol FetiLipCompatible {
    associatedtype CompatibleType
    var ex: CompatibleType { get }
}

public struct SingleAssociatedTypeContainer<Base, AssociatedType> {
    var base: Base
}
