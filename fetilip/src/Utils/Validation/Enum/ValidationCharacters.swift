//
//  ValidationCharacters.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/17.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

enum ValidationCharacters {
    case userName
    case password
    case review

    var max: Int {
        switch self {
        case .userName:
            return 12
        case .password:
            return 32
        case .review:
            return 1000
        }
    }

    var min: Int {
        switch self {
        case .userName:
            return 1
        case .password:
            return 6
        case .review:
            return 0
        }
    }

}
