//
//  RegisterUserViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - init

    struct Dependency {
        // Write properties
    }

    func inject(with dependency: Dependency) {
        // Write inject process.
    }

    typealias ViewModel = RegisterUserViewModel

    let viewModel: ViewModel = RegisterUserViewModel()

    // MARK: - Properties

    private lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "✗", style: .done, target: self, action: #selector(close))

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
    }

    // MARK: - Functions

    private func composeUI() {
        // Setup navigation controller
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.title = R._string.registerUserScreentTitle

        // TODO: Make common.
        self.navigationController?.navigationBar.backgroundColor = FetiLipColors.theme()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

}

final class RegisterUserViewControllerGenerator {

    private init() {}

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.registerUser.registerUserViewController() else {
            assertionFailure()
            return UIViewController()
        }
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
