//
//  TestUserAuthentications.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/06/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import XCTest
@testable import fetilip
import RxBlocking
import RxTest

class TestUserAuthentications: XCTestCase {

    let model: UserAuthModelProtocol = UsersAuthModel()

    let email = "test@example.com"

    let password = "password"

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

}

extension TestUserAuthentications {

    /// Register user with email and password
    func xtestCreateUserWithEmailAndPassword() throws {
        XCTContext.runActivity(named: "正常系") { _ in
            // emai
            XCTAssertEqual(try! model.createUserWithEmailAndPassword(email: email, password: password).toBlocking().single().email, email)
        }
    }
}
