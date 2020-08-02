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

    // MARK: - init

    init(postModel: PostModelClientProtocol) {
        self.postModel = postModel
        isLoading = activity.asObservable()
    }

    // MARK: - Properties

    /// Post model.
    private let postModel: PostModelClientProtocol

    let isLoading: Observable<Bool>

    /// Number of posts to retrieve at one time.
    private let limit: Int = 20

    private var loadedCount: Int = 0

    /// Store the lastv created date of the array of posts retrieved for paging.
    private var startAfter: Timestamp = Timestamp()

    /// Tracking observable.
    private let activity: ActivityIndicator = ActivityIndicator()

    private var data: [PostDomainModel] = []

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
        let loadingObservable: Observable<Bool>
    }

    func transform(input: PostListViewModel.Input) -> PostListViewModel.Output {
        let listLoadSequence = input.firstLoadEvent.flatMap { _ in
            return self.postModel.getPostList(limit: self.limit, startAfter: nil).flatMap { list -> Single<[PostListSectionDomainModel]> in
                return Single.create { observer in
                    let domains: [PostDomainModel] = list.map { PostDomainModel.convert($0) }
                    // Sort by dat created.
                    let sorted = domains.sorted(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })

                    self.data.append(contentsOf: sorted)
                    self.loadedCount += self.limit
                    // Save createdAt.
                    self.startAfter = sorted.last!.createdAt
                    let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]

                    observer(.success(sections))
                    return Disposables.create()
                }
            }.asObservable().share().trackActivity(self.activity)
        }

        // Load next page sequence.
        let nextLoadSequence: Observable<[PostListSectionDomainModel]> = input.nextPageEvent.flatMap { _ -> Observable<[PostListSectionDomainModel]> in
            guard self.loadedCount == self.data.count else {
                return Single.create { observer in
                    let sections = [PostListSectionDomainModel(items: self.data)]
                    observer(.success(sections))
                    return Disposables.create()
                }.trackActivity(self.activity)
            }
            return self.postModel.getPostList(limit: self.limit, startAfter: self.startAfter).flatMap { list in
                return Single.create { observer in
                    let domains: [PostDomainModel] = list.map { PostDomainModel.convert($0) }
                    let sorted = domains.sorted(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })

                    self.data.append(contentsOf: sorted)
                    if !sorted.isEmpty {
                        self.startAfter = sorted.last!.createdAt
                    }

                    self.loadedCount += self.limit

                    let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]
                    observer(.success(sections))
                    return Disposables.create()
                }
            }.trackActivity(self.activity)
        }

        let combined = Observable.merge(listLoadSequence, nextLoadSequence)

        return Output(loadResult: combined, loadingObservable: self.isLoading)
    }

}
