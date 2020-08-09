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

    private let isLoading: Observable<Bool>

    /// Number of posts to retrieve at one time.
    private let limit: Int = 20

    private var loadedCount: Int = 0

    /// Store the lastv created date of the array of posts retrieved for paging.
    private var lastDocument: DocumentSnapshot?

    /// Tracking observable.
    private let activity: ActivityIndicator = ActivityIndicator()

    private var data: [PostDomainModel] = []

}

// MARK: - Private functions

extension PostListViewModel {

}

extension PostListViewModel: ViewModelType {

    struct Input {
        let firstLoadEvent: Observable<LoadType>
    }

    struct Output {
        let loadResult: Observable<[PostListSectionDomainModel]>
        let loadingObservable: Observable<Bool>
    }

    func transform(input: PostListViewModel.Input) -> PostListViewModel.Output {
        let listLoadSequence = input.firstLoadEvent
            .filter{ type in self.loadedCount == self.data.count || type == .refresh}
            .flatMap { type -> Observable<[PostListSectionDomainModel]> in
            switch type {
            case .firstLoad:
                return self.postModel.getPostList(limit: self.limit, startAfter: nil).flatMap { (list, lastDoc) -> Single<[PostListSectionDomainModel]> in
                    return Single.create { observer in
                        let domains: [PostDomainModel] = list.map { PostDomainModel.convert($0) }
                        // Sort by dat created.

                        self.data.append(contentsOf: domains)
                        self.loadedCount += self.limit
                        // Save createdAt.
                        self.lastDocument = lastDoc
                        let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]

                        observer(.success(sections))
                        return Disposables.create()
                    }
                }.asObservable().trackActivity(self.activity)
            case .paging:
                return self.postModel.getPostList(limit: self.limit, startAfter: self.lastDocument).flatMap { (list, lastDoc) in
                    return Single.create { observer in
                        let domains: [PostDomainModel] = list.map { PostDomainModel.convert($0) }

                        self.data.append(contentsOf: domains)
                        self.lastDocument = lastDoc
                    
                        self.loadedCount += self.limit

                        let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]
                        observer(.success(sections))
                        return Disposables.create()
                    }
                }.trackActivity(self.activity)
            case .refresh:
                self.data.removeAll()
                self.lastDocument = nil
                self.loadedCount = 0
                return self.postModel.getPostList(limit: self.limit, startAfter: nil).flatMap { (list, lastDoc) -> Single<[PostListSectionDomainModel]> in
                    return Single.create { observer in
                        // Clear properties
                        self.data.removeAll()
                        self.lastDocument = nil
                        self.loadedCount = 0

                        let domains: [PostDomainModel] = list.map { PostDomainModel.convert($0) }
                        // Sort by dat created.

                        self.data.append(contentsOf: domains)
                        self.loadedCount += self.limit
                        // Save createdAt.
                        self.lastDocument = lastDoc
                        let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]

                        observer(.success(sections))
                        return Disposables.create()
                    }
                }.asObservable().trackActivity(self.activity)

            }
        }

        return Output(loadResult: listLoadSequence, loadingObservable: self.isLoading)
    }

}

enum LoadType {
    case firstLoad
    case paging
    case refresh
}
