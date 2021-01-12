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
        let updatePostEvent: PublishSubject<PostDomainModel>
    }

    public struct Output {

    }

    public func transform(input: Input) -> Output {
        return Output()
    }

}
