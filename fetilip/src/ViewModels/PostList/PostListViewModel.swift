//
//  PostListViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PostListViewModel {

    /// Event to transition to the lip posting page.
    private let transitionToPostLipEvent: PublishRelay<()> = PublishRelay<()>()

    private let disposeBag = DisposeBag()

}

extension PostListViewModel: ViewModelType {

    struct Input {
        let tapPostLipButtonSignal: Signal<()>
    }

    struct Output {
        let tapPostLipButtonEvent: Signal<()>
    }

    func transform(input: PostListViewModel.Input) -> PostListViewModel.Output {
        input.tapPostLipButtonSignal.emit(to: transitionToPostLipEvent).disposed(by: disposeBag)
        return Output(tapPostLipButtonEvent: transitionToPostLipEvent.asSignal())
    }

}
