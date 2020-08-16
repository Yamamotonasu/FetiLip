//
//  EditProfileViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FMPhotoPicker

/**
 * Edit profile screen view controller.
 */
// TODO: Edit profile function.
class EditProfileViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: Init process

    struct Dependency {
        let userDomainModel: UserDomainModel
    }

    typealias ViewModel = EditProfileViewModel

    let viewModel: ViewModel = EditProfileViewModel(userModel: UsersModelClient(), userStorageClient: UsersStorageClient())

    func inject(with dependency: Dependency) {
        self.userDomainModel = dependency.userDomainModel
    }

    // MARK: - Outlets

    @IBOutlet private weak var editProfileStackView: UIStackView!

    @IBOutlet private weak var profileImage: UIImageView!

    @IBOutlet private weak var userNameLabel: UILabel!

    @IBOutlet private weak var userNameView: UIStackView!

    @IBOutlet private weak var registerUserButton: UIButton!

    // MARK: - Properties

    private var userDomainModel: UserDomainModel?

    private let selectModeSuject: PublishSubject<SelectMode> = PublishSubject<SelectMode>()

    private let profileImageSubject: PublishSubject<UIImage?> = PublishSubject<UIImage?>()

    private let updateProfileImageSubject: PublishSubject<()> = PublishSubject<()>()

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
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
        // Setup navigation bar.
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = R._string.profileScreenTitle

        // Setup base information
        if self.userDomainModel?.hasImage == true {
            FirestorageLoader.loadImage(storagePath: self.userDomainModel!.imageRef).subscribe(onSuccess: { [weak self] image in
                self?.profileImage.image = image
            }).disposed(by: rx.disposeBag)
        } else {
            self.profileImage.image = R.image.default_icon_female()
        }

        userNameLabel.text = userDomainModel?.userName
    }

    private func subscribe() {
        let tapGesture = UITapGestureRecognizer()
        editProfileStackView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.presentingSelectMode()
        }).disposed(by: rx.disposeBag)

        let userNameTapGesture = UITapGestureRecognizer()
        userNameView.addGestureRecognizer(userNameTapGesture)
        userNameTapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.presentingEditProfileDetail(editProfileType: .userName(default: self.userDomainModel?.userName ?? ""))
        }).disposed(by: rx.disposeBag)

        selectModeSuject.asObservable().subscribe(onNext: { [unowned self] mode in
            switch mode {
            case .libary:
                self.launchLibrary()
            case .camera:
                self.launchCamera()
            case .editor:
                break
            }
        }).disposed(by: rx.disposeBag)

        registerUserButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.presentingRegisterUser()
        }).disposed(by: rx.disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(updateProfileImageEvent: updateProfileImageSubject.asObservable(), profileImageObservable: profileImageSubject.asObservable())
        let output = viewModel.transform(input: input)

        output.updateUserImageResult.subscribe(onNext: { _ in
                log.debug("Success update image")
            }, onError: { e in
                log.error("\(e.localizedDescription)")
        }).disposed(by: rx.disposeBag)

        output.loading.subscribe(onNext: { bool in
            if bool {
                AppIndicator.show()
            } else {
                AppIndicator.dismiss()
            }
        }).disposed(by: rx.disposeBag)

        output.profileImageDriver.drive(profileImage.rx.image).disposed(by: rx.disposeBag)
    }

    private func presentingSelectMode() {
        let vc = SelectModeViewControllerGenerator.generate(selectSubject: self.selectModeSuject)
        self.present(vc, animated: true)
    }

    private func presentingEditProfileDetail(editProfileType: EditProfileDetailType) {
        let vc = EditProfileDetailViewControllerGenerator.generate(editProfileType: editProfileType)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func presentingRegisterUser() {
        let vc = RegisterUserViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

}

// MARK: - FMPhotoPicker

extension EditProfileViewController: FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {

    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        profileImageSubject.onNext(photo)
        self.dismiss(animated: true) {
            self.updateProfileImageSubject.onNext(())
        }
    }

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if let image = photos.first {
            profileImageSubject.onNext(image)
        }
        self.dismiss(animated: true) {
            self.updateProfileImageSubject.onNext(())
        }
    }

    /// Launch library with app setting.
    private func launchLibrary() {
        let config = AppSettings.FMPhotoPickerSetting.setup()
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// Launch camera.
    private func launchCamera() {
        let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let camera = UIImagePickerController()
            camera.sourceType = sourceType
            camera.delegate = self
            self.present(camera, animated: true)
        }
    }

}

final class EditProfileViewControllerGenerator {

    private init() {}

    public static func generate(userDomainModel: UserDomainModel) -> UIViewController {
        guard let vc = R.storyboard.editProfile.editProfileViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(userDomainModel: userDomainModel))
        return vc
    }

}
