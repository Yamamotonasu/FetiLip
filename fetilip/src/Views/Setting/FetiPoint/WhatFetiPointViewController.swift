//
//  WhatFetiPointViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class WhatFetiPointViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
    }

    private func composeUI() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 0
        }
    }

}

final class WhatFetiPointViewControllerGenerator {

    private init() {}

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.whatFetiPoint.whatFetiPointViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
