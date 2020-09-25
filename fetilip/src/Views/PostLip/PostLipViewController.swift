//
//  PostLipViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/10.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import FMPhotoPicker
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import Firebase
import SwiftMessages

/**
 * ViewController for posting lips.
 */
class PostLipViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = PostLipViewModel

    var viewModel: ViewModel = PostLipViewModel(postModelClient: PostModelClient(),
                                                postStorageClient: PostsStorageClient(),
                                                userSocialClient: UserSocialClient(),
                                                userAuthModel: UsersAuthModel())

    // MARK: - Init process

    struct Dependency {
        // Write dependency object.
    }

    func inject(with dependency: PostLipViewController.Dependency) {
        // Write method inject process.
    }

    // MARK: - Outlets

    /// Button for adding lip image.
    @IBOutlet private weak var addImageButton: UIButton!

    /// Button to return to the previous screen.
    @IBOutlet private weak var dismissButton: UIButton!

    /// Button to post image.
    @IBOutlet private weak var postButton: UIButton!

    /// Image posted.
    @IBOutlet private weak var imagePosted: UIImageView!

    /// Description label.
    @IBOutlet private weak var descriptionLabel: UILabel!

    /// Delete image button.
    @IBOutlet private weak var deleteImageButton: UIButton!

    /// Where to display the selected image.
    @IBOutlet private weak var selectedImageViewArea: UIView!

    /// Review selected images.
    @IBOutlet private weak var postLipReviewTextView: PlaceHolderTextView!

    @IBOutlet private weak var templateSegumentedControl: UISegmentedControl!

    // MARK: - Properties

    private let selectModeSuject: PublishSubject<SelectMode> = PublishSubject<SelectMode>()

    private let checkLoginEvent: PublishRelay<()> = PublishRelay<()>()

    // MARK: - Flags

    /// Whether the user can post a review.
    private var canPostLip: Bool = false

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        bindUI()
        checkLoginEvent.accept(())
    }

}

// MARK: - Private functions

extension PostLipViewController {

    private func composeUI() {
        templateSegumentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: R.font.sourceHanSansBold(size: 14)!], for: .normal)
    }

    private func subscribe() {
        dismissButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.close()
        }).disposed(by: rx.disposeBag)

        addImageButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            guard self.canPostLip else {
                self.showNeedRegisterUserAlert()
                return
            }

            if self.imagePosted.image == nil {
                self.presentingSelectMode()
            } else {
                self.launchEditor()
            }
        }).disposed(by: rx.disposeBag)

        let tapGesture = UITapGestureRecognizer()
        selectedImageViewArea.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [unowned self] _ in
                if self.imagePosted.image == nil {
                    self.presentingSelectMode()
                }
            }).disposed(by: rx.disposeBag)

        selectModeSuject.asObservable().subscribe(onNext: { [unowned self] mode in
            switch mode {
            case .libary:
                self.launchLibrary()
            case .camera:
                self.launchCamera()
            case .editor:
                self.launchEditor()
            }
        }).disposed(by: rx.disposeBag)
    }

    /// Bind UI from view model outputs and ViewModel.
    private func bindUI() {
        let input = ViewModel.Input(deleteButtonTapEvent: deleteImageButton.rx.tap.asObservable(),
                                    checkLoginEvent: checkLoginEvent,
                                    postButtonTapEvent: postButton.rx.tap.asObservable(),
                                    postLipReviewText: postLipReviewTextView.rx.text.asObservable(),
                                    segumentedControlValueObservable: templateSegumentedControl.rx.value.asObservable())
        let output = viewModel.transform(input: input)

        output.updatedImage
            .bind(to: self.imagePosted.rx.image)
            .disposed(by: rx.disposeBag)

        output.updatedImage
            .map { $0 != nil }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] exists in
                self.deleteImageButton.isHidden = !exists
                self.descriptionLabel.isHidden = exists
                self.templateSegumentedControl.isHidden = !exists
                self.addImageButton.titleLabel?.text = exists ? R._string.view_message.editImage : R._string.view_message.selectImage
                self.postButton.alpha = exists ? 1.0 : 0.5
                self.imagePosted.borderColor = exists ? .white : .gray
                self.postLipReviewTextView.isHidden = !exists
            }).disposed(by: rx.disposeBag)

        output.templateTextDriver.drive(onNext: { [unowned self] text in
            self.postLipReviewTextView.text = text
            self.postLipReviewTextView.changeVisiblePlaceHolder()
        }).disposed(by: rx.disposeBag)

        output.postResult.retryWithAlert().subscribe(onNext: { [weak self] in
            ApplicationFlag.shared.updateNeedSocialUpdate(true)
            self?.dismiss(animated: true) {
                AppAlert.show(message: R._string.success.postSucceed, alertType: .success)
            }
        }).disposed(by: rx.disposeBag)

        output.checkLoginResult.subscribe(onNext: { [weak self] _ in
            self?.canPostLip = true
        },onError: { [weak self] _ in
            self?.canPostLip = false
            self?.showNeedRegisterUserAlert()
        }).disposed(by: rx.disposeBag)

        output.indicator.subscribe(onNext: { bool in
            if bool {
                AppIndicator.show()
            } else {
                AppIndicator.dismiss()
            }
        }).disposed(by: rx.disposeBag)
    }

    private func close() {
        self.dismiss(animated: true)
    }

    private func presentingSelectMode() {
        guard canPostLip else {
            showNeedRegisterUserAlert()
            return
        }
        let vc = SelectModeViewControllerGenerator.generate(selectSubject: self.selectModeSuject)
        self.present(vc, animated: true)
    }

    private func showNeedRegisterUserAlert() {
        AppAlert.show(message: R._string.needRegitserUser, alertType: .info)
    }

}

// MARK: - FMPhotoPicker

extension PostLipViewController: FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {

    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        viewModel.uploadedImage.accept(photo)
        self.dismiss(animated: true)
    }

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if let selected = photos.first {
            viewModel.uploadedImage.accept(selected)
        }
        self.dismiss(animated: true)
    }

    /// Launch library with app setting.
    private func launchLibrary() {
        AppSettings.libraryPermissionRequest { status in
            if status == .authorized {
                self.attachLibrary()
            }
        }
    }

    private func attachLibrary() {
        DispatchQueue.main.async {
            let config = AppSettings.FMPhotoPickerSetting.setup()
            let picker = FMPhotoPickerViewController(config: config)
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }

    /// /// Launch Editor with app setting.
    private func launchEditor(selectedImage: UIImage? = nil) {
        // TODO: refector
        if let image = imagePosted.image {
            let config = AppSettings.FMPhotoPickerSetting.setup()
            let picker = FMImageEditorViewController(config: config, sourceImage: image)
            picker.delegate = self
            self.present(picker, animated: true)
        } else if let selected = selectedImage {
            let config = AppSettings.FMPhotoPickerSetting.setup()
            let picker = FMImageEditorViewController(config: config, sourceImage: selected)
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }

}

extension PostLipViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// Called after selecting an image with the camera.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true) {
                self.launchEditor(selectedImage: image)
            }
        }
    }

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

/**
 * PostLipViewController generator.
 */
final class PostLipViewControllerGenerator {

    public init() {}

    public static func generate() -> UIViewController {
        guard let vc = R.storyboard.postLip.postLipViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init())
        return vc
    }

}

public enum SelectMode {
    case libary
    case camera
    case editor
}
