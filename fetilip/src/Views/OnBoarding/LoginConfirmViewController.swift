//
//  LoginConfirmViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/01.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class LoginConfirmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

final class LoginConfirmViewControllerGenerator {

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.loginConfirmViewController.loginConfirmViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
