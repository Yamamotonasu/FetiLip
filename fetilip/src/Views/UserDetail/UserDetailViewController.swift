//
//  UserDetailViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/10/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, ViewControllerMethodInjectable {

    struct Dependency {

        let displayUserDomainModel: UserDomainModelProtocol

    }

    func inject(with dependency: Dependency) {
        self.displayUserDomainModel = dependency.displayUserDomainModel
    }

    var displayUserDomainModel: UserDomainModelProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

final class UserDetailViewControllerGenerator {

    static func generate(userDomainModel: UserDomainModelProtocol) -> UIViewController {
        guard let vc = R.storyboard.userDetail.userDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
