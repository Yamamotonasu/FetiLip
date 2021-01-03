//
//  EmailValidation.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

typealias EmailValidator = ValidationContainer<String?, InvalidEmail>

let EMAIL_REGEX = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

enum InvalidEmail: InvalidStatus, Error {

    case empty

    case invalidFormat

}

extension InvalidEmail: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .empty:
            return R._string.validation.emptyInput
        case .invalidFormat:
            return R._string.validation.invalidEmailFormat
        }
    }

}

extension ValidationContainer where Target == String?, Invalid == InvalidEmail {

    func isNotEmpty() -> Self {
        return guarantee({ email in
            if let mail = email {
                return !mail.isEmpty
            } else {
                return false
            }
        }, otherwise: .empty)
    }

    func validFormat() -> Self {
        return guarantee({ text in
            let emailtst = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
            let result = emailtst.evaluate(with: text)
            return result
        }, otherwise: .invalidFormat)
    }

}
