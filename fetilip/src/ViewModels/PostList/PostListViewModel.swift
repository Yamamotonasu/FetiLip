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

}

class PostListViewModel: PostListViewModelProtocol {

    init(postModel: PostModelClientProtocol) {
        self.postModel = postModel
        fetchCompletionObservable = fetchCompletionSubject.asObservable()
    }

    private let postModel: PostModelClientProtocol

    private let fetchCompletionSubject: PublishRelay<[PostDomainModel]> = PublishRelay<[PostDomainModel]>()

    let fetchCompletionObservable: Observable<[PostDomainModel]>

    private let disposeBag = DisposeBag()

}

// MARK: - Private functions

extension PostListViewModel {

}

extension PostListViewModel: ViewModelType {

    struct Input {
        let firstLoadEvent: Observable<()>
    }

    struct Output {
        let loadResult: Observable<PostListSectionDomainModel>
    }

    func transform(input: PostListViewModel.Input) -> PostListViewModel.Output {
        let listLoadSequence = input.firstLoadEvent.flatMap { _ in
            return self.postModel.getPostList().flatMap { list -> Single<PostListSectionDomainModel> in
                return Single.create { observer in
                    let domains = list.map { PostDomainModel.convert($0) }
                    let sections = PostListSectionDomainModel(items: domains)
                    observer(.success(sections))
                    return Disposables.create()
                }
            }.asObservable()
        }

        return Output(loadResult: listLoadSequence)
    }

}
