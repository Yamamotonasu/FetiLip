//
//  MyPageViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyPageViewModelProtocol {

}

/**
 * MyPageViewController ViewModel
 */
struct MyPageViewModel: MyPageViewModelProtocol {

    // MARK: - init

    init(userModel: UsersModelClientProtocol, userSocialClient: UserSocialClientProtocol) {
        self.userModel = userModel
        self.userSocialClient = userSocialClient
    }

    // MARK: - properties

    private let userModel: UsersModelClientProtocol

    private let userSocialClient: UserSocialClientProtocol

}

// MARK: - ViewModelType

extension MyPageViewModel: ViewModelType {

    struct Input {
        let userLoadEvent: Observable<()>
        let userSocialLoadEvent: PublishRelay<()>
    }

    struct Output {
        let userLoadResult: Observable<UserDomainModel>
        let userSocialLoadResult: Observable<UserSocialDomainModel>
    }

    func transform(input: Input) -> Output {
        let userLoadResult = input.userLoadEvent.flatMap { _ in
            // TODO: replace uid
            return self.userModel.getUserData(userRef: LoginAccountData.userDocumentReference).flatMap { data -> Single<UserDomainModel> in
                return Single.create { observer in
                    ApplicationFlag.shared.updateNeedProfileUpdate(false)
                    let domain = UserDomainModel.convert(data)
                    observer(.success(domain))
                    return Disposables.create()
                }
            }
        }

        let userSocialLoadEvent = input.userSocialLoadEvent.flatMapLatest { _ in
            return self.userSocialClient.getUserSocial(uid: LoginAccountData.uid!).flatMap { data -> Single<UserSocialDomainModel> in
                return Single.create { observer in
                    ApplicationFlag.shared.updateNeedSocialUpdate(false)
                    let domain = UserSocialDomainModel.convert(data)
                    observer(.success(domain))
                    return Disposables.create()
                }
            }
        }

        return Output(userLoadResult: userLoadResult,
                      userSocialLoadResult: userSocialLoadEvent)
    }

}
