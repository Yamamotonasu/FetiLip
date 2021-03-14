//
//  SelectModeViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectModeViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    // MARK: - Init process

    struct Dependency {
        let selectSubject: PublishSubject<SelectMode>
    }

    private var selectSubject: PublishSubject<SelectMode> = PublishSubject<SelectMode>()

    func inject(with dependency: SelectModeViewController.Dependency) {
        selectSubject = dependency.selectSubject
    }

    // MARK: - Outlets

    /// Camera button.
    @IBOutlet private weak var cameraButton: UIButton!

    /// Library button.
    @IBOutlet private weak var libraryButton: UIButton!

    // MARK: - Properties

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

    override func viewDidAppear(_ animated: Bool) {
        guard LoginAccountData.isPayAttensionBeforePosting == false else {
            let vc = PayAttensionPostingImageViewControllerGenerater.generate()
            self.present(vc, animated: true)
            return
        }
    }

}

// MARK: - Private functions

extension SelectModeViewController {

    private func subscribe() {
        cameraButton.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.selectSubject.onNext(.camera)
            }
        }).disposed(by: disposeBag)

        libraryButton.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.selectSubject.onNext(.libary)
            }
        }).disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}

/**
 * SelectModeViewController generator.
 */
final class SelectModeViewControllerGenerator {

    public init() {}

    public static func generate(selectSubject: PublishSubject<SelectMode>) -> UIViewController {
        guard let vc = R.storyboard.selectMode.selectModeViewController() else {
            assertionFailure()
            return UIViewController()
        }

        vc.inject(with: .init(selectSubject: selectSubject))
        return vc
    }

}
