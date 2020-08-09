//
//  TransitionPostPageViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/10.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class TransitionPostPageViewController: UIViewController {

    // MARK: - ViewModel

    typealias ViewModel = PostListViewModel

    var viewModel: ViewModel = PostListViewModel(postModel: PostModelClient())

    /// Button to transition to the lip posting page.
    @IBOutlet weak var transitionPostPageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeUI()
    }

}

// MARK: - Private functions

extension TransitionPostPageViewController {

    /// Bind UI from view model outputs.
    private func subscribeUI() {
        transitionPostPageButton.rx.tap.asSignal().emit(onNext: { [unowned self] _ in
            self.transitionPostLipScene()
        }).disposed(by: rx.disposeBag)
    }

    /// Transition post lip page.
    private func transitionPostLipScene() {
        touchStartAnimation()
        touchEndAnimation()
        let vc = PostLipViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

    private func touchStartAnimation() {
        UIView.animate(withDuration: 0.1,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {() -> Void in
                self.transitionPostPageButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.transitionPostPageButton.alpha = 0.7
            },
            completion: nil
        )
    }
    private func touchEndAnimation() {
        UIView.animate(withDuration: 0.1,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {() -> Void in
                self.transitionPostPageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.transitionPostPageButton.alpha = 1
            },
            completion: nil
        )
    }

}
