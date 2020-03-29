//
//  GlobalTabBarController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import PTCardTabBar

class GlobalTabBarController: UITabBarController {

}

// MARK: MakeInstance

extension GlobalTabBarController {

    static func makeInstance() -> UITabBarController {
        guard let tab = R.storyboard.globalTabBar.globalTabBarController() else {
            assertionFailure()
            return GlobalTabBarController()
        }
        return tab
    }

}
