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
