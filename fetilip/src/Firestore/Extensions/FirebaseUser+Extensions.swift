//
//  FirebaseUser+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import FirebaseAuth

extension User {

    public enum AuthError: Error {
        case UnauthenticatedError
        case notInitialized(error: Error)
        case notLoginError
        case failedLogout(error: Error)
    }

}
