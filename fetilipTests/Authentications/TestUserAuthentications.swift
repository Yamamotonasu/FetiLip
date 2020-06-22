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
import Nimble
import Quick
import FirebaseAuth

/**
 * Testing user firebase authentication.
 */
class TestUserAuthenticationModel: QuickSpec {

    /// Testing model.
    let model: UserAuthModelProtocol = UsersAuthModel()

    /// Email exists authentication and firestore.
    let email = "test@example.com"

    /// password exists authentication and firestore.
    let password = "password"

    override func spec() {

        describe("UserAuthenticationModel") {
            describe("loginWithEmailAndPassword()") {
                it("Expect succeed") {
                    expect { try self.model.loginWithEmailAndPassword(email: self.email, password: self.password).toBlocking().single().uid }.to(equal(Auth.auth().currentUser?.uid))
                }

                it("Expect failed") {
                    // Convert to unregister email address.
                    let dummyEmail = self.email + "com"
                    let dummyPassword = "aaa"
                    expect { try self.model.loginWithEmailAndPassword(email: dummyEmail, password: dummyPassword).toBlocking().single() }.to(throwError(FirebaseUser.AuthError.notLoginError))
                }
            }

            describe("createAnonymousUser()") {
                it("Expect succeed") {
                    // TODO:
                }
            }

            describe("checkLogin()") {
                it("Expect succeed") {
                    // TODO:
                }

                it("Expect failed") {
                    // TODO:
                }
            }

            describe("createUserWithEmailAndPassword(email:password:)") {
                it("Expect succeed") {
                    // TODO:
                }

                it("Expect failed") {
                    // TODO:
                }
            }

            describe("logout") {
                it("Expect succeed") {
                    // TODO:
                }
            }
        }
    }

}
