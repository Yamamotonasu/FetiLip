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

/**
 * ViewController for posting lips.
 */
class PostLipViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = PostLipViewModel

    var viewModel: ViewModel = PostLipViewModel()

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


    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        bindUI()
    }

}

// MARK: - Private functions

extension PostLipViewController {

    private func subscribe() {
        dismissButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.close()
        }).disposed(by: rx.disposeBag)

        addImageButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.launchCameraOrLibrary()
        }).disposed(by: rx.disposeBag)

        let tapGesture = UITapGestureRecognizer()
        selectedImageViewArea.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .observeOn(MainScheduler.instance).bind(onNext: { [unowned self] _ in
                self.launchCameraOrLibrary()
            }).disposed(by: rx.disposeBag)
    }

    /// Bint UI from view model outputs and ViewModel.
    private func bindUI() {
        let input = ViewModel.Input(deleteButtonTapEvent: deleteImageButton.rx.tap.asObservable(),
                                    postButtonTapEvent: postButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        output.updatedImage
            .bind(to: self.imagePosted.rx.image)
            .disposed(by: rx.disposeBag)

        output.updatedImage
            .flatMapLatest { image in
                return Observable.just(image != nil)
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] exists in
            self.deleteImageButton.isHidden = !exists
            self.descriptionLabel.isHidden = exists
            self.postButton.isEnabled = exists
            self.postButton.alpha = exists ? 1.0 : 0.5
            self.imagePosted.borderColor = exists ? .white : .gray
        }).disposed(by: rx.disposeBag)

    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

}

extension PostLipViewController: FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {

    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        viewModel.updatedImage.accept(photo)
    }

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if let selected = photos.first {
            viewModel.updatedImage.accept(selected)
        }
        self.dismiss(animated: true)
    }

    private func launchCameraOrLibrary() {
        var config = FMPhotoPickerConfig()
        config.mediaTypes = [.image]
        config.selectMode = .single
        config.maxImage = 1
        config.forceCropEnabled = true
        config.availableCrops = [
            FMCrop.ratioSquare
        ]
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
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
