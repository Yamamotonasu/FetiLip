//
//  ArrayExtensionsTests.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/03/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import XCTest
@testable import fetilip

/// Array extensions tests
class ArrayExtensionsTests: XCTestCase {

    let testArray = [1, 2, 3, 4, 5]

    let emptyArray = [Int]()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

}

// MARK: - remove()

extension ArrayExtensionsTests {

    /// 削除成功
    func testRemoveSuccess() {
        XCTAssertEqual(testArray.ex.remove(5), [1, 2, 3, 4])
    }

    /// 合致する要素が無ければ何も起きない
    func testRemoveSuccess2() {
        XCTAssertEqual(testArray.ex.remove(6), [1, 2, 3, 4, 5])
    }

    /// 空配列に対して実行すると何も起きない
    func testRemoveSuccess3() {
        XCTAssertEqual(emptyArray.ex.remove(1), [])
    }

}

// MARK: - replace()

extension ArrayExtensionsTests {

    func xtestRemoveSuccess() {
        // TODO: Equatableに適合したModelを定義したら書く
    }
}

// MARK: - insertOrUpdate()

extension ArrayExtensionsTests {

    func xtestInsertOrUpdate() {
        // TODO: Equatableに適合したModelを定義したら書く
    }

}

// MARK: - appendIfPossible()

extension ArrayExtensionsTests {

    /// 追加正常系
    func testAppendIfPossibleSuccess() {
        XCTAssertEqual(testArray.ex.appendIfPossible(6), [1, 2, 3, 4, 5, 6])
    }

    /// nilは追加されない
    func testAppendIfPossibleSuccess2() {
        XCTAssertEqual(testArray.ex.appendIfPossible(nil), [1, 2, 3, 4, 5])
    }

}
