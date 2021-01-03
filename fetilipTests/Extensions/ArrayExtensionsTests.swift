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

    func testRemoveSuccess() {
        XCTContext.runActivity(named: "正常系") { _ in
            XCTContext.runActivity(named: "正常に追加出来る") { _ in
                XCTAssertEqual(testArray.ex.remove(5), [1, 2, 3, 4])
            }

            XCTContext.runActivity(named: "合致する要素が無ければ何も起きない") { _ in
                XCTAssertEqual(testArray.ex.remove(6), [1, 2, 3, 4, 5])
            }

            XCTContext.runActivity(named: "空配列に対して実行すると何も起きない") { _ in
                XCTAssertEqual(emptyArray.ex.remove(1), [])
            }
        }
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
    func testAppendIfPossible() {
        XCTContext.runActivity(named: "正常系") { _ in
            XCTContext.runActivity(named: "正常に追加出来る") { _ in
                XCTAssertEqual(testArray.ex.appendIfPossible(6), [1, 2, 3, 4, 5, 6])
            }

            XCTContext.runActivity(named: "nilは追加されない") { _ in
                XCTAssertEqual(testArray.ex.appendIfPossible(nil), [1, 2, 3, 4, 5])
            }
        }
    }

}
