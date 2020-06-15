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
        let input = ViewModel.Input(tapPostLipButtonSignal: transitionPostPageButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.tapPostLipButtonEvent.emit(onNext: { [unowned self] _ in
            self.transitionPostLipScene()
        }).disposed(by: rx.disposeBag)
    }

    /// Transition post lip page.
    private func transitionPostLipScene() {
        let vc = PostLipViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

}
