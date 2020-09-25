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

    // MARK: - init

    private init() {}

    private static let ud = UserDefaults.standard

    /// User Defaults keys
    private enum DataType: String {
        /// Firebase authentication uid.
        case uid = "uid"

        case payAttension = "payAttension"

    }

    // MARK: - properties

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

    /// Whether to pay attension to the posted image before posting
    static var isPayAttensionBeforePosting: Bool? {
        get {
            self.ud.object(forKey: Self.DataType.payAttension.rawValue) as? Bool
        }
        set {
            self.ud.set(newValue, forKey: Self.DataType.payAttension.rawValue)
        }
    }

    // TODO: Unwrapp
    static let userDocumentReference: DocumentReference = Firestore.firestore().document("\(AppSettings.FireStore.rootDocumentName)/\(UserModel.collectionName)/\(String(describing: uid!))")

    /// Reset login user data
    static func resetUserData() {
        Self.uid = nil
    }

}
