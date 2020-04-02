//
//  DebugViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * Debugやテスト用ViewController
 */
class DebugViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var backButton: UIButton!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

}

// MARK: Private function

extension DebugViewController {

    private func subscribe() {
        /// 前の画面へ戻る
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
    }

}

// MARK: Make instance

extension DebugViewController {

    public static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.debug.debugViewController() else {
            return UIViewController()
        }
        return vc
    }

}
