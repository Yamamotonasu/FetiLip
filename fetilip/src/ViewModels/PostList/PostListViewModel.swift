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
import Firebase

protocol PostListViewModelProtocol {

}

class PostListViewModel: PostListViewModelProtocol {

    /// Paging limit.
    private let limit: Int = 30

    private var startAfter: Timestamp = Timestamp()

    init(postModel: PostModelClientProtocol) {
        self.postModel = postModel
    }

    private let postModel: PostModelClientProtocol

}

// MARK: - Private functions

extension PostListViewModel {

}

extension PostListViewModel: ViewModelType {

    struct Input {
        let firstLoadEvent: Observable<()>
        let nextPageEvent: Observable<()>
    }

    struct Output {
        let loadResult: Observable<[PostListSectionDomainModel]>
    }

    func transform(input: PostListViewModel.Input) -> PostListViewModel.Output {
        let listLoadSequence = input.firstLoadEvent.flatMap { _ in
            return self.postModel.getPostList(limit: self.limit, startAfter: nil).flatMap { list -> Single<[PostListSectionDomainModel]> in
                return Single.create { observer in
                    let domains: [PostDomainModel] = list.map { PostDomainModel.convert($0) }
                    // Save limit.
                    self.startAfter = domains.last!.createdAt
                    let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: domains)]
                    observer(.success(sections))
                    return Disposables.create()
                }
            }.asObservable()
        }

        let nextLoadSequence = input.nextPageEvent.flatMap { _ in
                return self.postModel.getPostList(limit: self.limit, startAfter: self.startAfter)
            }

        return Output(loadResult: listLoadSequence)
    }

}
