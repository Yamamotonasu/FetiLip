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

    private func convertPostDomainModel(entities: [PostModel.FieldType], documents: [DocumentSnapshot]) -> [PostDomainModel] {
        var domains: [PostDomainModel] = []
        if entities.count == documents.count {
            let refs = documents.map { $0.reference }
            for index in 0..<entities.count {
                domains.append(PostDomainModel.convertWithDocumentReference(entities[index], documentReference: refs[index]))
            }
        } else {
            assertionFailure()
            domains.append(contentsOf: entities.map { PostDomainModel.convert($0) })
        }
        return domains
    }

    private func refreshMyPost() -> Observable<[PostListSectionDomainModel]> {
        self.data.removeAll()
        self.lastDocument = nil
        self.loadedCount = 0
        return self.postModel.getSpecifyUserPostList(targetUid: LoginAccountData.uid!, limit: self.limit, startAfter: nil).flatMap { (list, documents) -> Single<[PostListSectionDomainModel]> in
            return Single.create { observer in
                // Clear properties
                self.data.removeAll()
                self.lastDocument = nil
                self.loadedCount = 0

                let domains: [PostDomainModel] = self.convertPostDomainModel(entities: list, documents: documents)
                // Sort by dat created.

                self.data.append(contentsOf: domains)
                self.loadedCount += self.limit
                // Save createdAt.
                self.lastDocument = documents.last
                let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]

                observer(.success(sections))
                return Disposables.create()
            }
        }.trackActivity(self.activity)
    }

    private func refreshPost() -> Observable<[PostListSectionDomainModel]> {
        self.data.removeAll()
        self.lastDocument = nil
        self.loadedCount = 0
        return self.postModel.getPostList(limit: self.limit, startAfter: nil).flatMap { (list, documents) -> Single<[PostListSectionDomainModel]> in
            return Single.create { observer in
                // Clear properties
                self.data.removeAll()
                self.lastDocument = nil
                self.loadedCount = 0

                let domains: [PostDomainModel] = self.convertPostDomainModel(entities: list, documents: documents)
                // Sort by dat created.

                self.data.append(contentsOf: domains)
                self.loadedCount += self.limit
                // Save createdAt.
                self.lastDocument = documents.last
                let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]

                observer(.success(sections))
                return Disposables.create()
            }
        }.asObservable().trackActivity(self.activity)
    }

}

extension PostListViewModel: ViewModelType {

    struct Input {
        let firstLoadEvent: Observable<LoadType>
        let deleteSubject: PublishSubject<DocumentReference>
        let refreshSubject: PublishSubject<RefreshLoadType>
    }

    struct Output {
        let loadResult: Observable<[PostListSectionDomainModel]>
        let refreshResult: Observable<[PostListSectionDomainModel]>
        let deleteResult: Observable<[PostListSectionDomainModel]>
        let loadingObservable: Observable<Bool>
    }

    func transform(input: PostListViewModel.Input) -> PostListViewModel.Output {
        let listLoadSequence = input.firstLoadEvent
            .filter { _ in self.loadedCount == self.data.count }
            .flatMap { type -> Observable<[PostListSectionDomainModel]> in
            switch type {
            case .firstLoad:
                return self.postModel.getPostList(limit: self.limit, startAfter: nil).flatMap { (list, documents) -> Single<[PostListSectionDomainModel]> in
                    return Single.create { observer in
                        let domains: [PostDomainModel] = self.convertPostDomainModel(entities: list, documents: documents)
                        // Sort by dat created.

                        self.data.append(contentsOf: domains)
                        self.loadedCount += self.limit
                        // Save createdAt.
                        self.lastDocument = documents.last
                        let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]

                        observer(.success(sections))
                        return Disposables.create()
                    }
                }.asObservable().trackActivity(self.activity)
            case .paging:
                return self.postModel.getPostList(limit: self.limit, startAfter: self.lastDocument).flatMap { (list, documents) in
                    return Single.create { observer in
                        let domains: [PostDomainModel] = self.convertPostDomainModel(entities: list, documents: documents)

                        self.data.append(contentsOf: domains)
                        self.lastDocument = documents.last

                        self.loadedCount += self.limit

                        let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]
                        observer(.success(sections))
                        return Disposables.create()
                    }
                }.trackActivity(self.activity)
            case .myPost:
                return self.postModel.getSpecifyUserPostList(targetUid: LoginAccountData.uid!,
                                                             limit: self.limit,
                                                             startAfter: nil).flatMap { (list, documents) -> Single<[PostListSectionDomainModel]> in
                                                                return Single.create { observer in
                                                                    let domains: [PostDomainModel] = self.convertPostDomainModel(entities: list, documents: documents)

                                                                    self.data.append(contentsOf: domains)
                                                                    self.lastDocument = documents.last

                                                                    self.loadedCount += self.limit

                                                                    let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]
                                                                    observer(.success(sections))
                                                                    return Disposables.create()
                                                                }
                }.trackActivity(self.activity)
            case .myPostPaging:
                return self.postModel.getSpecifyUserPostList(targetUid: LoginAccountData.uid!,
                                                             limit: self.limit,
                                                             startAfter: self.lastDocument).flatMap { (list, documents) ->Single<[PostListSectionDomainModel]> in
                                                                return Single.create { observer in
                                                                    let domains: [PostDomainModel] = self.convertPostDomainModel(entities: list, documents: documents)

                                                                    self.data.append(contentsOf: domains)
                                                                    self.lastDocument = documents.last

                                                                    self.loadedCount += self.limit

                                                                    let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]
                                                                    observer(.success(sections))
                                                                    return Disposables.create()
                                                                }
                                                             }.trackActivity(self.activity)
            }
        }

        let deleteSequence = input.deleteSubject.flatMapLatest { documentReference -> Single<[PostListSectionDomainModel]> in
            return Single.create { observer in
                self.data = self.data.filter { $0.documentReference != documentReference }
                let sections: [PostListSectionDomainModel] = [PostListSectionDomainModel(items: self.data)]
                observer(.success(sections))
                return Disposables.create()
            }
        }.asObservable()

        let refreshSequence = input.refreshSubject.flatMapLatest { loadType -> Observable<[PostListSectionDomainModel]> in
            switch loadType {
            case .refreshMyPost:
                return self.refreshMyPost()
            case .refresh:
                return self.refreshPost()
            }
        }

        return Output(loadResult: listLoadSequence,
                      refreshResult: refreshSequence,
                      deleteResult: deleteSequence,
                      loadingObservable: self.isLoading)
    }

}

enum LoadType {
    case firstLoad
    case paging
    case myPost
    case myPostPaging
}

enum RefreshLoadType {
    case refresh
    case refreshMyPost
}
