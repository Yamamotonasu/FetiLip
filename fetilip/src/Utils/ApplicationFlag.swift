//
//  ApplicationFlag.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/30.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * App event flags.
 */
struct ApplicationFlag {

    // MARK: - init

    static var shared: Self = ApplicationFlag()

    private init() {}

    // MARK: - Properties

    public var needProfileUpdate: Bool = false

    public var needUserSocialUpdate: Bool = false

    // MARK: - Functions

    public mutating func updateNeedProfileUpdate(_ flag: Bool) {
        needProfileUpdate = flag
    }

    public mutating func updateNeedSocialUpdate(_ flag: Bool) {
        needUserSocialUpdate = flag
    }

    public mutating func clearFlags() {
        needProfileUpdate = true
        needUserSocialUpdate = true
    }

}
