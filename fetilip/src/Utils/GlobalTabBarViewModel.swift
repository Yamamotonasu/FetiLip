//
//  GlobalTabBarViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/31.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GlobalTabBarViewModel {

    init(userAuthModel: UserAuthModelProtocol, userBlockClient: UserBlockClientProtocol) {
        self.userAuthModel = userAuthModel
        self.userBlockClient = userBlockClient
    }

    let userAuthModel: UserAuthModelProtocol

    let userBlockClient: UserBlockClientProtocol

}

extension GlobalTabBarViewModel: ViewModelType {

    struct Input {
        let checkLoginEvent: PublishRelay<()>
        let getBlockUser: PublishRelay<()>
    }

    struct Output {
        let checkLoginResult: Observable<()>
        let getBlockUsersResult: Observable<[UserBlockDomainModel]>
    }

    func transform(input: Input) -> Output {
        let checkLoginSequence = input.checkLoginEvent.flatMap {
            return self.userAuthModel.checkLogin().flatMap { _ -> Single<()> in
                Single.create { observer in
                    observer(.success(()))
                    return Disposables.create()
                }
            }
        }

        let getBlockUserSequence: Observable<[UserBlockDomainModel]> = input.getBlockUser.flatMap {
            return self.userBlockClient.getUserBlocks(uid: LoginAccountData.uid!)
        }.flatMapLatest { blockUsers in
            return Observable.create { observer in
                let domains: [UserBlockDomainModel] = blockUsers.map { UserBlockDomainModel.convert($0) }
                domains.forEach { GlobalData.shared.blokingUserUids.append($0.targetUid) }
                observer.on(.next(domains))
                return Disposables.create()
            }
        }
        return Output(checkLoginResult: checkLoginSequence, getBlockUsersResult: getBlockUserSequence)
    }

}
