//
//  EditProfileDetailViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * Edit profile detail view controller.
 */
class EditProfileDetailViewController: UIViewController, ViewControllerMethodInjectable {

    struct Dependency {
        let editProfileType: EditProfileDetailType
    }

    func inject(with dependency: Dependency) {
        self.editProfileDetailType = dependency.editProfileType
    }

    typealias ViewModel = EditProfileDetailViewModel

    private let viewModel: ViewModel = EditProfileDetailViewModel(userModelClient: UsersModelClient())

    // MARK: - Properties

    private var editProfileDetailType: EditProfileDetailType!

    private lazy var rightSaveButton: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveProfile))

    // MARK: - Rx

    private let updateProfileSubject: PublishSubject<EditProfileDetailType> = PublishSubject<EditProfileDetailType>()

    // MARK: - Outlets

    @IBOutlet private weak var editInformationTextView: UITextView!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribeUI()
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
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = rightSaveButton

        switch editProfileDetailType {
        case .userName(let defaults):
            editInformationTextView.text = defaults
            self.navigationItem.title = R._string.profileScreenTitle
        default:
            break
        }
    }

    private func subscribeUI() {
        let input = ViewModel.Input(textFieldObservable: editInformationTextView.rx.text.asObservable(), updateProfileEvent: updateProfileSubject.asObservable())
        let output = viewModel.transform(input: input)

        output.updateResult.subscribe(onNext: { [weak self] _ in
            log.debug("Success update information.")
            self?.navigationController?.popViewController(animated: true)
        }, onError: { e in
            log.error("Failed update. reason: \(e.localizedDescription)")
        }).disposed(by: rx.disposeBag)

    }

    @objc private func saveProfile() {
        updateProfileSubject.onNext(.userName(default: ""))
    }

}

final class EditProfileDetailViewControllerGenerator {

    private init() {}

    static func generate(editProfileType: EditProfileDetailType) -> UIViewController {
        guard let vc = R.storyboard.editProfileDetail.editProfileDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(editProfileType: editProfileType))
        return vc
    }

}

public enum EditProfileDetailType {

    case userName(default: String)

    case none
}
