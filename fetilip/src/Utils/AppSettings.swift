//
//  AppSettings.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/09.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FMPhotoPicker
import UIKit

/// Struct that summarizes the setting values related to the Fetilip application.
public struct AppSettings {

    /// TabBarBottomHeight
    static let tabBarHeight: CGFloat = 60

    /// Tab bar bottom constraint.
    static let tabBarBottomMargin: CGFloat = 20

    /// Setting value related to Firestore.
    struct FireStore {

        /// Root document reference.
        static let rootDocumentName: String = "version/\(Self.version)"

        /// Version control reference.
        static let version: String = "1"

    }

    /// Setting config related to FMPhotoPicker.
    struct FMPhotoPickerSetting {

        static func setup() -> FMPhotoPickerConfig {
            var config = FMPhotoPickerConfig()
            config.mediaTypes = [.image]
            config.selectMode = .single
            config.maxImage = 1
            config.forceCropEnabled = true
            config.availableCrops = [
                FMCrop.ratioSquare
            ]
            return config
        }

    }

}
