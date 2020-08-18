//
//  PasswordValidation.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/17.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

typealias PasswordValidator = ValidationContainer<String?, InvalidPassword>

enum InvalidPassword: InvalidStatus, Error {

    case empty
    case tooShort(minCount: Int)
    case tooLong(maxCount: Int)

    var message: String {
        switch self {
        case .empty:
            return "パスワードが入力されていません。"
        case .tooShort:
            return "パスワードは\(ValidationCharacters.password.min)文字以上で入力してください。"
        case .tooLong:
            return "パスワードは\(ValidationCharacters.password.max)文字以内で入力してください。"
        }
    }

}

extension ValidationContainer where Target == String?, Invalid == InvalidPassword {

    /// 文字列は空文字ではない
    func isNotEmpty() -> Self {
        return guarantee({ password in
            if let p = password {
                return !p.isEmpty
            } else {
                return false
            }
        }, otherwise: .empty)
    }

    /// 文字列は最大でmaxDigitsである
    func lessThanDigits() -> Self {
        let maxDigits = ValidationCharacters.password.max
        return guarantee({ input in
            if let i = input {
                return i.count <= maxDigits
            } else {
                return false
            }
        }, otherwise: .tooLong(maxCount: maxDigits))
    }

    /// パスワードの最小はmaxDigitsである
    func greaterThanDigits() -> Self {
        let minDigits = ValidationCharacters.password.min
        return guarantee({ input in
            if let i = input {
                return i.count >= minDigits
            } else {
                return false
            }}, otherwise: .tooShort(minCount: minDigits))
    }

}
