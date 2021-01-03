//
//  TestUserAuthentications.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/06/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
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
class TestUserAuthenticationModel: QuickSpec, LoginFunction {

    var selfUid: String?

    /// Testing model.
    let model: UserAuthModelProtocol = UsersAuthModel()

    /// Email exists authentication and firestore.
    let email = TestingInformation.testUserEmail

    /// password exists authentication and firestore.
    let password = TestingInformation.testUserPassword

    override func spec() {

        describe("UserAuthenticationModel") {

            afterEach {
                self.logout() { _ in }
            }

            describe("loginWithEmailAndPassword()") {
                it("Expect succeed") {
                    expect { try self.model.loginWithEmailAndPassword(email: self.email, password: self.password).toBlocking().single() }.to(beAnInstanceOf(FirebaseUser.self))
                }

                it("Expect failed") {
                    // Convert to unregister email address.
                    let dummyEmail = self.email + "com"
                    let dummyPassword = "aaa"
                    expect { try self.model.loginWithEmailAndPassword(email: dummyEmail, password: dummyPassword).toBlocking().single() }.to(throwError { error in
                        expect(AuthErrorCode(rawValue: error._code)).to(equal(AuthErrorCode.userNotFound))
                    })
                }
            }

            describe("createAnonymousUser()") {
                xit("Expect succeed") {
                    expect { try self.model.createAnonymousUser().toBlocking().single() }.to(beAnInstanceOf(FirebaseUser.self))
                }
            }

            describe("checkLogin()") {
                it("Expect succeed") {
                    self.login(email: self.email, password: self.password) { result in
                        expect { try self.model.checkLogin().toBlocking().single() }.to(beAnInstanceOf(FirebaseUser.self))
                    }
                }

                it("Expect failed") {
                    expect { try self.model.checkLogin().toBlocking().single() }.to(throwError(User.AuthError.currentUserNotFound))
                }
            }

            describe("createUserWithEmailAndPassword(email:password:)") {
                xit("Expect succeed") {
                    let newEmail = "new_test_user@email.com"
                    expect { try self.model.createUserWithEmailAndPassword(email: newEmail, password: self.password).toBlocking().single() }.to(beAnInstanceOf(FirebaseUser.self))
                }

                it("Expect failed") {
                    let dummyEmail = "dummy_email@co.com"
                    let dummyPassword = "aaa"
                    expect { try self.model.createUserWithEmailAndPassword(email: dummyEmail, password: dummyPassword).toBlocking().single() }.to(throwError { error in
                            expect(AuthErrorCode(rawValue: error._code)).to(equal(AuthErrorCode.weakPassword))
                        })
                    }
                }
            }

            describe("logout") {
                beforeEach {
                    self.login(email: self.email, password: self.password) { _ in }
                }
                it("Expect succeed") {
                    expect { try self.model.logout().toBlocking().single() }.to(beAnInstanceOf(Void.self))
                }
            }
        }
    }


