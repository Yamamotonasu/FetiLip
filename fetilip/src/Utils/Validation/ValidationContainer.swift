//
//  ValidationContainer.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

protocol InvalidStatus: Equatable {}

/**
 * Validation status for input characters.
 */
enum ValidationStatus<Invalid: InvalidStatus> {

    case valid

    case invalid(Invalid)

}

/**
 * Validation container.
 * 実際のバリデーション用Container。Validate配下にextensionでバリデーションパターンを追加できる
 */
struct ValidationContainer<Target, Invalid: InvalidStatus> {

    /// Input characters
    private let target: Target

    /// 有効な入力 → .valud 無効な入力 → .invalid(status:)
    private let invalid: Invalid?

    private func finish() -> ValidationStatus<Invalid> {
        if let invalid = invalid {
            return .invalid(invalid)
        } else {
            return .valid
        }
    }

    static func validate(_ target: Target, with validation: (Self) -> Self) -> ValidationStatus<Invalid> {
        let container = Self.init(target: target, invalid: nil)
        let result = validation(container).finish()

        return result
    }

    func guarantee(_ condition: (Target) -> Bool, otherwise invalidStatus: Invalid) -> Self {
        guard invalid == nil else {
            return self
        }
        if condition(target) == true {
            return self
        } else {
            return ValidationContainer(target: target, invalid: invalidStatus)
        }
    }

}
