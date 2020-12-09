//
//  UserDetailViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/10/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserDetailViewModelProtocol {

}

public struct UserDetailViewModel {

    init(userSocialClient: UserSocialClientProtocol) {
        self.userSocialClient = userSocialClient
    }

    private let userSocialClient: UserSocialClientProtocol

}

extension UserDetailViewModel: ViewModelType {

    public struct Input {
        let firstLoadEvent: PublishSubject<String>
    }

    public struct Output {
        let userSocialDataDriver: Driver<UserSocialDomainModel>
    }

    public func transform(input: Input) -> Output {
        let userSocialLoadSequence: Observable<UserSocialDomainModel> = input.firstLoadEvent.flatMap { uid in
            self.userSocialClient.getUserSocial(uid: uid)
        }.flatMapLatest { entity in
            Observable.create { observer in
                let domain = UserSocialDomainModel.convert(entity)
                observer.on(.next(domain))
                return Disposables.create()
            }
        }
        return Output(userSocialDataDriver: userSocialLoadSequence.asDriver(onErrorDriveWith: Driver<UserSocialDomainModel>.empty()))
    }

}
