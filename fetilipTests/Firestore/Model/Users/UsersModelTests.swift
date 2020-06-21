//
//  UsersModelTests.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/06/20.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import XCTest
@testable import fetilip

class UsersModelTests: XCTestCase {

    let model: UsersModelClientProtocol = UsersModelClient()

    override class func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPerformanceExample() throws {
        self.measure {}
    }

}

// MARK: - Write

extension UsersModelTests {

    /// Initial commit test
    func testInitialCommit() {
        XCTContext.runActivity(named: "正常系") { _ in

        }
    }

    /// Initial commit test
    func testupdateUserName() {
        XCTContext.runActivity(named: "正常系") { _ in

        }
    }

    func testUpdateProfile() {
        XCTContext.runActivity(named: "正常系") { _ in

        }
    }

}

// MARK: - Read

extension UsersModelTests {

    func testCurrentUserFetch() {

    }
}


