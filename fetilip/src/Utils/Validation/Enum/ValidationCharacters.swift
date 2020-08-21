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

    var max: Int {
        switch self {
        case .userName:
            return 10
        case .password:
            return 32
        }
    }

    var min: Int {
        switch self {
        case .userName:
            return 1
        case .password:
            return 6
        }
    }

}
