//
//  SettingsViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import MessageUI
import RxSwift

class SettingsViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet private weak var termCell: UITableViewCell!

    @IBOutlet private weak var privacyPolicyCell: UITableViewCell!

    @IBOutlet private weak var whatsFetiPointCell: UITableViewCell!

    @IBOutlet private weak var contactCell: UITableViewCell!

    // MARK: - Properties

    private let disposeBag = DisposeBag()

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
            case self.whatsFetiPointCell:
                self.showWhatFetiPoint()
            case self.contactCell:
                self.startMailer()
            default:
                break
            }
        }).disposed(by: disposeBag)
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

    private func showWhatFetiPoint() {
        let vc = WhatFetiPointViewControllerGenerator.generate()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func startMailer() {
        guard MFMailComposeViewController.canSendMail() else {
            AppAlert.show(message: R._string.error.failedToStartMailer, alertType: .error)
            return
        }
        let mailerViewController = MFMailComposeViewController()
        mailerViewController.mailComposeDelegate = self
        mailerViewController.setToRecipients([Constants.contactAdress])
        mailerViewController.setSubject(Constants.defaultContactSubject)
        mailerViewController.setMessageBody(Constants.defaultContactBody, isHTML: false)

        self.present(mailerViewController, animated: true)
    }

}

// MARK: - MFMailCompose

extension SettingsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            AppAlert.show(message: R._string.success.successSendMail, alertType: .info)
            break
        case .failed:
            break
        default:
            break
        }
        controller.dismiss(animated: true)
    }

}

final class SettingsViewControllerGenerator {

    private init() {}

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.setting.settingsViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
