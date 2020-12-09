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
import Photos

/// Struct that summarizes the setting values related to the Fetilip application.
public struct AppSettings {

    /// TabBarBottomHeight
    static let tabBarHeight: CGFloat = 60

    /// Tab bar bottom constraint.
    static let tabBarBottomMargin: CGFloat = 20

    /// Setting value related to Firestore.
    struct FireStore {

        /// Root document reference.
        static let rootDocumentName: String = "/version/\(Self.version)"

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

    /// Library permission request.
    ///  If user has already granted access to the library, invoke completion handler with .authorized, else invoke it with other each status with show alert.
    static func libraryPermissionRequest(completion: @escaping (PHAuthorizationStatus) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        // - .notDetermined: Explicit user permission is required for photo library access, but the user has not yet granted or denied such permission.
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    completion(.authorized)
                case .denied:
                    completion(.denied)
                case .restricted:
                    completion(.restricted)
                default:
                    break
                }
            }
        // The user has explicitly granted this app access to the photo library.
        case .authorized:
            completion(.authorized)
            break
        // The user has explicitly denied your app access to the photo library.
        case .denied:
            AppAlert.show(message: R._string.requestUserLibraryPermission, alertType: .info)
            completion(.denied)
            break
        // Your app is not authorized to access the photo library, and the user cannot grant such permission.
        case .restricted:
            AppAlert.show(message: R._string.requestUserLibraryPermission, alertType: .info)
            completion(.restricted)
            break
        @unknown default:
            break
        }
    }

}
