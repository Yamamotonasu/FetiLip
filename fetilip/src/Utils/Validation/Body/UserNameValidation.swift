//
//  UserNameValidation.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

typealias UserNameValidator = ValidationContainer<String?, InvalidUserName>

enum InvalidUserName: InvalidStatus, Error {

    case empty

    case tooShort(minCount: Int)

    case tooLong(maxCount: Int)

    var message: String {
        switch self {
        case .empty:
            return R._string.validation.emptyUserName
        case .tooShort(let minCount):
            return R._string.validation.tooShortName(minimum: minCount)
        case .tooLong(let maxCount):
            return R._string.validation.tooLongName(maximum: maxCount)
        }
    }

}

extension ValidationContainer where Target == String?, Invalid == InvalidUserName {

    func isNotEmpty() -> Self {
        return guarantee({ password in
            if let p = password {
                return !p.isEmpty
            } else {
                return false
            }
        }, otherwise: .empty)
    }

    func lessThanDigits() -> Self {
        let maxDigits = ValidationCharacters.userName.max
        return guarantee({ input in
            if let i = input {
                return i.count <= maxDigits
            } else {
                return false
            }
        }, otherwise: .tooLong(maxCount: maxDigits))
    }

    func greaterThanDigits() -> Self {
        let minDigits = ValidationCharacters.userName.min
        return guarantee({ input in
            if let i = input {
                return i.count >= minDigits
            } else {
                return false
            }}, otherwise: .tooShort(minCount: minDigits))
    }

}
