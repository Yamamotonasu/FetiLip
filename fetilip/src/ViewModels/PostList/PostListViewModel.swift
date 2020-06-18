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

protocol PostListViewModelProtocol {

    /// Fetch lip list.
    func fetchList()

}

class PostListViewModel: PostListViewModelProtocol {

    init(postModel: PostModelClientProtocol) {
        self.postModel = postModel
        fetchCompletionObservable = fetchCompletionSubject.asObservable()
    }

    private let postModel: PostModelClientProtocol

    /// Event to transition to the lip posting page.
    private let transitionToPostLipEvent: PublishRelay<()> = PublishRelay<()>()

    private let fetchCompletionSubject: PublishRelay<[PostDomainModel]> = PublishRelay<[PostDomainModel]>()

    let fetchCompletionObservable: Observable<[PostDomainModel]>

    private let disposeBag = DisposeBag()

}

// MARK: - Private functions

extension PostListViewModel {

    func fetchList() {
        postModel.getPostList()
            .do()
            .map { $0.filter { $0.fields != nil }.map { PostDomainModel.convert($0.fields!) } }
            .subscribe(onSuccess: { postDomains in
                let newDomain = postDomains.filter { $0.image != nil }
                self.fetchCompletionSubject.accept(newDomain)
            }) { e in
                log.error(e.localizedDescription)
        }.disposed(by: disposeBag)

    }

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
