//
//  ValidationError.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Custom validation error enum.
 */
public enum ValidationError: Error {

    case emptyInput

    case tooLongCharacters(maximum: Int)

    var errorMessage: String {
        switch self {
        case .emptyInput:
            return R._string.validation.emptyInput
        case .tooLongCharacters(let maximum):
            return R._string.validation.tooLongInput(maximum: maximum)
        }
    }

}
