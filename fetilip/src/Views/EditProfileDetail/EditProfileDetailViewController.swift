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
import FloatingPanel

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

    private let viewModel: ViewModel = EditProfileDetailViewModel(userModelClient: UsersModelClient(), userAuthModel: UsersAuthModel())

    // MARK: - Properties

    private var editProfileDetailType: EditProfileDetailType!

    private var floatingPanelController: FloatingPanelController!

    private let disposeBag = DisposeBag()

    private lazy var rightSaveButton: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveProfile))

    // MARK: - Rx

    private var updateProfileSubject: BehaviorSubject<EditProfileDetailType>?

    private var defaultInformationSubject: BehaviorSubject<String>?

    private let inputPasswordSubject: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    private let saveInputInformationEvent: PublishSubject<()> = PublishSubject<()>()

    // MARK: - Outlets

    @IBOutlet private weak var editInformationTextView: UITextView!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileSubject = BehaviorSubject<EditProfileDetailType>(value: editProfileDetailType)
        composeUI()
        subscribe()
        subscribeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 0
        }
        setupHalfModal()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 1
        }
        floatingPanelController.dismiss(animated: true)
    }

    private func setupHalfModal() {
        floatingPanelController = FloatingPanelController()

        let modalViewController = InputPasswordViewControllerGenerator.generate(inputPasswordSubject: inputPasswordSubject, saveInformationSubject: saveInputInformationEvent)
        floatingPanelController.set(contentViewController: modalViewController)
        floatingPanelController.isRemovalInteractionEnabled = true

        floatingPanelController.delegate = self
    }

    // MARK: - Functions

    private func composeUI() {
        // Setup navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightSaveButton

        editInformationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

        // Setup edit mode
        switch editProfileDetailType {
        case .userName(let defaults):
            editInformationTextView.text = defaults
            self.navigationItem.title = R._string.editUserNameScreenTitle
        case .email(let defaults):
            editInformationTextView.text = defaults
            self.navigationItem.title = R._string.editEmailScreenTitle
        default:
            break
        }
    }

    private func subscribe() {
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.floatingPanelController.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(textFieldObservable: editInformationTextView.rx.text.asObservable(),
                                    passwordTextObservable: inputPasswordSubject.asObservable(),
                                    updateProfileEvent: updateProfileSubject?.asObservable() ?? Observable.empty(),
                                    saveProfileEvent: saveInputInformationEvent)
        let output = viewModel.transform(input: input)

        output.updateResult.retryWithAlert().subscribe(onNext: { [weak self] _ in
            ApplicationFlag.shared.updateNeedProfileUpdate(true)
            AppAlert.show(message: R._string.success.updateInformation, alertType: .success)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

        output.indicator.subscribe(onNext: { bool in
            if bool {
                AppIndicator.show()
            } else {
                AppIndicator.dismiss()
            }
        }).disposed(by: disposeBag)
    }

    @objc private func saveProfile() {
        switch editProfileDetailType {
        case .userName:
            saveInputInformationEvent.onNext(())
        case .email:
            self.present(floatingPanelController, animated: true)
        default:
            break
        }
    }

}

// MARK: - Floating panel delegate methods

extension EditProfileDetailViewController: FloatingPanelControllerDelegate {

    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        switch targetPosition {
        case .top:
            vc.dismiss(animated: true)
        case .left:
            log.debug("left dragging.")
        case .right:
            log.debug("right dragging")
        case .bottom:
            log.debug("bottom dragging")
        @unknown default:
            break
        }
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

    case email(default: String)

    case none

}
