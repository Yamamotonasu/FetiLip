//
//  PayAttensionPostingImageViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift

class PayAttensionPostingImageViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var okButton: UIButton!

    // MARK: - Properties

    private let disposeBag = DisposeBag()

    // MARK: - LifyCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

    // MARK: - Functions

    private func subscribe() {
        okButton.rx.tap.asSignal().emit(onNext: { _ in
            LoginAccountData.isPayAttensionBeforePosting = false
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }

}

final class PayAttensionPostingImageViewControllerGenerater {

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.payAttensionPostingImage.payAttensionPostingImageViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
