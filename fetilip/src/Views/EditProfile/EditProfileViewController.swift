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
class EditProfileViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: Init process

    struct Dependency {
        let userDomainModel: UserDomainModel
    }

    typealias ViewModel = EditProfileViewModel

    let viewModel: ViewModel = EditProfileViewModel(userModel: UsersModelClient())

    func inject(with dependency: Dependency) {
        self.userDomainModel = dependency.userDomainModel
    }

    // MARK: - Outlets

    @IBOutlet private weak var editProfileStackView: UIStackView!

    @IBOutlet private weak var profileImage: UIImageView!

    // MARK: - Properties

    private var userDomainModel: UserDomainModel?

    private let selectModeSuject: PublishSubject<SelectMode> = PublishSubject<SelectMode>()

    private var profileImageRelay: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        subscribeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            UIView.animate(withDuration: 0.1) {
                tab.customTabBar.alpha = 0
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            UIView.animate(withDuration: 0.1) {
                tab.customTabBar.alpha = 1
            }
        }
    }

    // MARK: - Functions

    private func composeUI() {
        // Setup navigation bar.
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "プロフィールを編集する"
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item

        // Setup base information
        if self.userDomainModel?.hasImage == true {
            FirestorageLoader.loadImage(storagePath: self.userDomainModel?.imageRef ?? "").subscribe(onSuccess: { [weak self] image in
                self?.profileImage.image = image
            }).disposed(by: rx.disposeBag)
        } else {
            self.profileImage.image = R.image.default_icon_female()
        }
    }

    private func subscribe() {
        let tapGesture = UITapGestureRecognizer()
        editProfileStackView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.presentingSelectMode()
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
    }

    private func subscribeUI() {
        let input = ViewModel.Input(profileImageObservable: profileImageRelay.asObservable())
        let output = viewModel.transform(input: input)

        output.profileImageDriver.drive(profileImage.rx.image).disposed(by: rx.disposeBag)
    }

    private func presentingSelectMode() {
        let vc = SelectModeViewControllerGenerator.generate(selectSubject: self.selectModeSuject)
        self.present(vc, animated: true)
    }

}

// MARK: - FMPhotoPicker

extension EditProfileViewController: FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {

    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        profileImageRelay.accept(photo)
        self.dismiss(animated: true)
    }

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if let image = photos.first {
            profileImageRelay.accept(image)
        }
        self.dismiss(animated: true)
    }

    /// Launch library with app setting.
    private func launchLibrary() {
        let config = AppSettings.FMPhotoPickerSetting.setup()
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }

//    /// /// Launch Editor with app setting.
//    private func launchEditor(selectedImage: UIImage? = nil) {
//        // TODO: refector
//        if let image = imagePosted.image {
//            let config = AppSettings.FMPhotoPickerSetting.setup()
//            let picker = FMImageEditorViewController(config: config, sourceImage: image)
//            picker.delegate = self
//            self.present(picker, animated: true)
//        } else if let selected = selectedImage {
//            let config = AppSettings.FMPhotoPickerSetting.setup()
//            let picker = FMImageEditorViewController(config: config, sourceImage: selected)
//            picker.delegate = self
//            self.present(picker, animated: true)
//        }
//    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    /// Called after selecting an image with the camera.
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.dismiss(animated: true) {
//                self.launchEditor(selectedImage: image)
//            }
//        }
//    }

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
