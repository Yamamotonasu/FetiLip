//
//  AuthErrorHandler.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/27.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseAuth

/**
 * Auth error handler class.
 */
public struct AuthErrorHandler {

    static func errorCode(_ error: Error) -> AuthErrorCode {
        if let e = AuthErrorCode(rawValue: error._code) {
            return e
        } else {
            return AuthErrorCode.appNotAuthorized
        }
    }

}

extension AuthErrorCode: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return R._string.invalidEmail
        case .weakPassword:
            return R._string.weakPassword
        case .emailAlreadyInUse:
            return R._string.emailAlreadyInUse
        case .wrongPassword:
            return R._string.wrongPassword
        case .userNotFound:
            return R._string.userNotFound
        case .internalError:
            return R._string.internalError
        case .userTokenExpired:
            return R._string.userTokenExpired
        case .userDisabled:
            return R._string.userDisabled
        case .appNotAuthorized:
            return R._string.errorOccurred
        default:
            return R._string.errorOccurred
        }
    }

}
