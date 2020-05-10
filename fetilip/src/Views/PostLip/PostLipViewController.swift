//
//  PostLipViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/10.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import FMPhotoPicker

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

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        bindUI()
    }

}

// MARK: - Private functions

extension PostLipViewController {

    private func composeUI() {
        // Swipe down to close the ViewController.
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.close))
        downSwipeGesture.direction = .down
        view.addGestureRecognizer(downSwipeGesture)
    }

    private func subscribe() {

        dismissButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.close()
        }).disposed(by: rx.disposeBag)

        addImageButton.rx.tap.asSignal().emit(onNext: { [unowned self]_ in
            self.launchCameraOrLibrary()
        }).disposed(by: rx.disposeBag)
    }

    /// Bint UI from view model outputs.
    private func bindUI() {

    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

}

extension PostLipViewController: FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {

    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        self.imagePosted.image = photo
    }

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if let selected = photos.first {
            self.imagePosted.image = selected
            self.imagePosted.borderColor = .white
            self.descriptionLabel.isHidden = true
        }
        self.dismiss(animated: true)
    }

    private func launchCameraOrLibrary() {
        var config = FMPhotoPickerConfig()
        config.mediaTypes = [.image]
        config.selectMode = .single
        config.maxImage = 1
        config.forceCropEnabled = false
        config.availableCrops = [
            FMCrop.ratioSquare,
            FMCrop.ratioCustom,
            FMCrop.ratio4x3,
            FMCrop.ratio16x9,
            FMCrop.ratio9x16,
            FMCrop.ratioOrigin,
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
