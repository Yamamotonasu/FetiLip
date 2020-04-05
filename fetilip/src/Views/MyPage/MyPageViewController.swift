//
//  MyPageViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * マイページ
 */
class MyPageViewController: UIViewController {

    // MARK: Outlets

    /// デバッグ用画面へ遷移する為の
    @IBOutlet private weak var debugButton: UIButton!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

}

// MARK: Private functions

extension MyPageViewController {

    /// Rx subscribe
    private func subscribe() {
        debugButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.transitionDebugScreen()
        }).disposed(by: rx.disposeBag)
    }

    /// デバッグ画面へ遷移する
    private func transitionDebugScreen() {
        let vc = DebugViewControllerGenerator.generate(viewModel: DebugViewModel())
        self.present(vc, animated: true)
    }

}
