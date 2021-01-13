//
//  EditPostViewModel.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/10.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

protocol EditPostViewModelProtocol {

}

public struct EditPostViewModel: EditPostViewModelProtocol {

    init(postModel: PostModelClientProtocol) {
        self.postModel = postModel
    }

    let postModel: PostModelClientProtocol

}

extension EditPostViewModel: ViewModelType {

    public struct Input {
        let reviewTextObservable: Observable<String?>
        let updatePostEvent: PublishSubject<PostDomainModel>
    }

    public struct Output {
        let updatePostResult: Observable<()>
    }

    public func transform(input: Input) -> Output {
        let combine = Observable.combineLatest(input.updatePostEvent.asObservable(), input.reviewTextObservable)
        let updateSequence = input.updatePostEvent.withLatestFrom(combine).flatMapLatest { (postDomainModel, review) in
            return postModel.updatePost(targetReference: postDomainModel.documentReference!, review: review ?? "")
        }
        return Output(updatePostResult: updateSequence)
    }

}
