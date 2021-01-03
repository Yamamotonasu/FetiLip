//
//  PostModelTests.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/06/28.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
@testable import fetilip
import Nimble
import Quick

class PostModelTests: QuickSpec, LoginFunction {

    var selfUid: String?

    /// Testing model.
    let model: PostModelClientProtocol = PostModelClient()

    /// Email exists authentication and firestore.
    let email = TestingInformation.testUserEmail

    /// password exists authentication and firestore.
    let password = TestingInformation.testUserPassword

    override func spec() {

        // 画像保存とFirestoreへのデータ保存出来る方法を考える
//        describe("PostModelClient") {
//            describe("postImage") {
//                xit("Expect succeed") {
//                    self.login(email: self.email, password: self.password) { _ in
//                        let uid = self.selfUid
//                        let image: UIImage = #imageLiteral(resourceName: "lip_image")
//                        let imageBase64: String? = image.base64
//                        expect { try self.model.postImage(uid: uid!, review: "", imageRef: imageBase64!).toBlocking().single() }.to(beAnInstanceOf(NSObject.self))
//                    }
//                }
//            }
//        }
    }

}
