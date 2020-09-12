//
//  RemoteConfigParameters.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/**
 * Enum class manage remote config parameters
 */
public enum RemoteConfigParameters {

    /// Minimum required app version.
    case requiredAppVersion

    /// Review template
    case reviewTemplate

    var parameter: String {
        switch self {
        case .requiredAppVersion:
            return "required_app_version"
        case .reviewTemplate:
            return "review_template"
        }
    }

    static let remoteConfigModel: RemoteConfigModel = RemoteConfigModel()

    var value: RemoteConfigValue? {
        return Self.remoteConfigModel.remoteConfig.configValue(forKey: self.parameter)
    }

    var stringValue: String? {
        return self.value?.stringValue?.replacingOccurrences(of: "<br/>", with: "\n")
    }

    var numberValue: NSNumber? {
        return self.value?.numberValue
    }

    var boolValue: Bool {
        return self.value?.boolValue ?? false
    }

}
