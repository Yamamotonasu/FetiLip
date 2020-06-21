//
//  LoginFunctions.swift
//  fetilipTests
//
//  Created by 山本裕太 on 2020/06/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
@testable import fetilip

/**
 * Login function for unit tests.
 */
protocol LoginFunction {

    /// Cunnrent user's uid.
    var selfUid: String { get set }

}

extension LoginFunction {

//    func login()
}
