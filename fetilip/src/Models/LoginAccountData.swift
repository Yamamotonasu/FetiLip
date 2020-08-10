//
//  LoginAccountData.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/09.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * Login account data. (Singleton object)
 */
struct LoginAccountData {

    private init() {}

    private static let ud = UserDefaults.standard

    /// User Defaults keys
    private enum DataType: String {
        // uid
        case uid = "uid"
    }

    /// Unique id for each Users
    static var uid: String? {
        get {
            self.ud.object(forKey: Self.DataType.uid.rawValue) as? String
        }
        set {
            self.ud.set(newValue, forKey: Self.DataType.uid.rawValue)
            self.ud.synchronize()
        }
    }

    static let userDocumentReference: DocumentReference = Firestore.firestore().document("/version/1/users/\(String(describing: uid))")

    /// Reset login user data
    static func resetUserData() {
        Self.uid = nil
    }

}
