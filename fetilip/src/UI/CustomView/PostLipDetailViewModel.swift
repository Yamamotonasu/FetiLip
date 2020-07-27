//
//  PostLipDetailViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/19.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol PostLipDetailViewModelProtocol {

}

/**
 * PostLipDetailViewModel
 */
struct PostLipDetailViewModel: PostLipDetailViewModelProtocol {

    init(userModel: UsersModelClientProtocol) {
        self.userModel = userModel
    }

    private let userModel: UsersModelClientProtocol

}

extension PostLipDetailViewModel: ViewModelType {

    struct Input {
        let firstLoadEvent: Observable<PostDomainModel>
    }

    struct Output {
        let userDataObservable: Driver<UserDomainModel>
    }

    func transform(input: Self.Input) -> Self.Output {
        let userLoadSequence = input.firstLoadEvent.flatMapLatest { postDomain -> Observable<UserModel.FieldType> in
            return self.userModel.getUserData(userRef: postDomain.userRef).asObservable()
        }.flatMapLatest { userEntity -> Single<UserDomainModel> in
            return Single.create { observer in
                observer(.success(UserDomainModel.convert(userEntity)))
                return Disposables.create()
            }
        }

        return Output(userDataObservable: userLoadSequence.asDriver(onErrorDriveWith: Driver.empty()))
    }

}
