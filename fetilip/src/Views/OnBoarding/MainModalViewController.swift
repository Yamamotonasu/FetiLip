//
//  MainModalViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/31.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainModalViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var termAndPrivacyPolicyTextView: UITextView!

    @IBOutlet private weak var startFetilipButton: UIButton!

    @IBOutlet private weak var checkBoxButton: UIButton!

    private var checkedBox: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        setupTermAndPrivacyPolicy()
        subscribe()
    }

    private func composeUI() {
        startFetilipButton.isEnabled = false
        startFetilipButton.alpha = 0.5
        self.checkBoxButton.setImage(R.image.square(), for: .normal)
    }

    private func setupTermAndPrivacyPolicy() {
        let term = "利用規約"
        let privacyPolicy = "プライバシーポリシー"
        let baseString = "\(term)、\(privacyPolicy)に同意する。"
        let attributedString = NSMutableAttributedString(attributedString: termAndPrivacyPolicyTextView.attributedText )

        attributedString.addAttribute(.link,
                                      value: "Term",
                                      range: NSString(string: baseString).range(of: term))

        attributedString.addAttribute(.link,
                                      value: "PrivacyPolicy",
                                      range: NSString(string: baseString).range(of: privacyPolicy))

        termAndPrivacyPolicyTextView.attributedText = attributedString
        termAndPrivacyPolicyTextView.isSelectable = true
        termAndPrivacyPolicyTextView.isEditable = false
        termAndPrivacyPolicyTextView.delegate = self
    }

    private func subscribe() {
        checkBoxButton.rx.tap
            .map { [unowned self] in
                !self.checkedBox
        }
            .bind(onNext: { [unowned self] enabled in
                self.startFetilipButton.isEnabled = enabled
                self.startFetilipButton.alpha = enabled ? 1.0 : 0.5
                let image = enabled ? R.image.square_theme() : R.image.square()
                self.checkBoxButton.setImage(image, for: .normal)
                self.checkedBox = !self.checkedBox
            }).disposed(by: rx.disposeBag)

        startFetilipButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
    }

}

// MARK: - TextViewDelegate

extension MainModalViewController: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // TODO: Link setting.
        UIApplication.shared.open(URL)
        return false
    }

}

final class MainModalViewControllerGenerator {

    static func generate() -> UIViewController {
        guard let vc = R.storyboard.mainModal.mainModalViewController() else {
            assertionFailure()
            return UIViewController()
        }
        return vc
    }

}
