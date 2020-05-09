//
//  FetilipBuildScheme.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/09.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Struct that determining the build scheme being started.
 */
public struct FetilipBuildScheme {

    /// Whether DEBUG build.
    static var DEBUG: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// Whether PRODUCTION build.
    static var PRODUCTION: Bool {
        #if PRODUCTION
            return true
        #else
            return false
        #endif
    }

}
