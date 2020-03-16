//
//  ViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/15.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: Make Instance

extension ViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.main.mainViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}

