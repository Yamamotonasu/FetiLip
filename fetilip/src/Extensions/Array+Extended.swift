//
//  Array+Extended.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

extension Array: FetiLipCompatible {

    public var ex: SingleAssociatedTypeContainer<Array<Element>, Element> {
        return SingleAssociatedTypeContainer(base: self)
    }

}

// MARK: Properties

extension SingleAssociatedTypeContainer where Base == Array<AssociatedType> {

    /// 配列の中身をランダムで返す
    public var random: AssociatedType? {
        guard !self.base.isEmpty else { return nil }
        let index = Int(arc4random_uniform(UInt32(self.base.count)))
        return self.base[index]
    }

    /// 配列の最後のIndex番号を返す
    public var lastIndex: Int {
        if self.base.count == 0 { return 0 }
        return self.base.count - 1
    }

}

// MARK: Subscripts

extension SingleAssociatedTypeContainer where Base == Array<AssociatedType> {

}

// MARK: Static functions

extension SingleAssociatedTypeContainer where Base == Array<AssociatedType> {

}

// MARK: Public functions(Conform Equatable)

extension SingleAssociatedTypeContainer where Base == Array<AssociatedType>, AssociatedType : Equatable {

    /// 配列から指定した要素を削除する
    public mutating func remove(_ element: AssociatedType) {
        if let index = self.base.firstIndex(of: element) {
            self.base.remove(at: index)
        }
    }

    /// 配列から要素を置き換える
    public mutating func replace(_ element: AssociatedType) {
        if let index = self.base.firstIndex(of: element) {
            self.base.remove(at: index)
            self.base.insert(element, at: index)
        }
    }

    public mutating func insertOrUpdate(_ element: AssociatedType) {
        if let index = self.base.firstIndex(of: element) {
            self.base.remove(at: index)
            self.base.insert(element, at: index)
        } else {
            self.base.append(element)
        }
    }

}

// MARK: Public functions

extension SingleAssociatedTypeContainer where Base == Array<AssociatedType> {

    public mutating func appendIfPossible(_ element: AssociatedType?) {
        guard let e = element else { return }
        self.base.append(e)
    }

}
