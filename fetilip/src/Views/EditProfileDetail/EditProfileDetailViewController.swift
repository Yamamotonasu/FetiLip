//
//  EditProfileDetailViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

/**
 * Edit profile detail view controller.
 */
class EditProfileDetailViewController: UIViewController {

    // MARK: - Properties

    var editProfileDetailType: EditProfileDetailType!

    private lazy var rightSaveButton: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveProfile))

    // MARK: - Outlets

    @IBOutlet private weak var userNameTextView: UITextView!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        self.navigationItem.rightBarButtonItem = rightSaveButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 0
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 1
        }
    }

    // MARK: - Functions

    private func composeUI() {
        switch editProfileDetailType {
        case .userName(let defaults):
            userNameTextView.text = defaults
        default:
            break
        }
    }

    @objc private func saveProfile() {

    }

}

final class EditProfileDetailViewControllerGenerator {

    private init() {}

    static func generate(editProfileType: EditProfileDetailType) -> UIViewController {
        guard let vc = R.storyboard.editProfileDetail.editProfileDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.editProfileDetailType = editProfileType
        return vc
    }

}

public enum EditProfileDetailType {

    case userName(default: String)

}
