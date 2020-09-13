//
//  SettingsViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet private weak var termCell: UITableViewCell!

    @IBOutlet private weak var privacyPolicyCell: UITableViewCell!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 0
        }
    }

    // MARK: - Functions

    private func subscribe() {
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            switch cell {
            case self.termCell:
                self.showTerm()
            case self.privacyPolicyCell:
                self.showPrivacyPolicy()
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
    }

    private func composeUI() {
        // Setup navigation bar.
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = R._string.settingScreenTitle
    }

    private func showTerm() {
        guard let url = URL(string: RemoteConfigParameters.termUrl.stringValue ?? Constants.termUrl) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

    private func showPrivacyPolicy() {
        guard let url = URL(string: RemoteConfigParameters.privacyPolicy.stringValue ?? Constants.privacyPolicyUrl) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}

final class SettingsViewControllerGenerator {

    static func generate() -> UIViewController  {
        guard let vc = R.storyboard.setting.settingsViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
