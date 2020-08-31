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

    @IBOutlet weak var termAndPrivacyPolicyTextView: UITextView!

    @IBOutlet weak var startFetilipButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTermAndPrivacyPolicy()
        subscribe()
    }

    private func setupTermAndPrivacyPolicy() {
        let term = "利用規約"
        let privacyPolicy = "プライバシーポリシー"
        let baseString = "\(term)、\(privacyPolicy)に同意する。"
        let attributedString = NSMutableAttributedString(string: baseString)

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
        startFetilipButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
    }

}

// MARK: - TextViewDelegate

extension MainModalViewController: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
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
