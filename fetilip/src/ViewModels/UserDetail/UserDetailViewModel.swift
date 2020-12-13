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

/// UserDetailViewModel.BlockType: Type of block.
/// String: targetUid
typealias UserBlockType = (UserDetailViewModel.BlockType, String)

protocol UserDetailViewModelProtocol {

}

public struct UserDetailViewModel {
    
    enum BlockType {
        case add
    }

    init(userSocialClient: UserSocialClientProtocol, userBlockClient: UserBlockClientProtocol) {
        self.userSocialClient = userSocialClient
        self.userBlockClient = userBlockClient
        isLoading = activity.asObservable()
    }

    private let isLoading: Observable<Bool>

    private let userSocialClient: UserSocialClientProtocol
    
    private let userBlockClient: UserBlockClientProtocol

    /// Tracking observable.
    private let activity: ActivityIndicator = ActivityIndicator()

}

extension UserDetailViewModel: ViewModelType {

    public struct Input {
        let firstLoadEvent: PublishSubject<String>
        let userBlockSubject: PublishSubject<UserBlockType>
    }

    public struct Output {
        let userSocialDataDriver: Driver<UserSocialDomainModel>
        let userBlockResult: Observable<()>
        let loading: Observable<Bool>
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
        
        let userBlockSequence: Observable<()> = input.userBlockSubject.flatMap { (type, targetUid) -> Observable<()> in
            switch type {
            case .add:
                return self.userBlockClient.setUserBlocks(uid: LoginAccountData.uid!, targetUid: targetUid).trackActivity(self.activity)
            }
        }.flatMap { _ in
            Observable.create { observer in
                observer.on(.next(()))
                return Disposables.create()
            }
        }

        return Output(userSocialDataDriver: userSocialLoadSequence.asDriver(onErrorDriveWith: Driver<UserSocialDomainModel>.empty()),
                      userBlockResult: userBlockSequence,
                      loading: self.isLoading)
    }

}
