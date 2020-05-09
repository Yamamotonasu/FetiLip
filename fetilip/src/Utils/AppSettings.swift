//
//  AppSettings.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/09.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Struct that summarizes the setting values related to the Fetilip application.
public struct AppSettings {

    /// Setting value related to Firestore.
    struct FireStore {

        /// Root document reference.
        static let rootDocumentName: String = "version/\(Self.version)"

        /// Version control reference.
        static let version: String = "1"

    }

}
