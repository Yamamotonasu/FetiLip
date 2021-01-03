//
//  LoginConfirmViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/01.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginConfirmViewModelProtocol {

}

struct LoginConfirmViewModel: LoginConfirmViewModelProtocol {

    // MARK: - init

    init(userAuthModel: UserAuthModelProtocol) {
        self.userAuthModel = userAuthModel
        self.indicator = activity.asObservable()
    }

    // MARK: - Properties

    private let userAuthModel: UserAuthModelProtocol

    private let activity: ActivityIndicator = ActivityIndicator()

    // MARK: - Rx

    private let indicator: Observable<Bool>

}

extension LoginConfirmViewModel: ViewModelType {

    struct Input {
        let createAnonymousUserEvent: PublishRelay<()>
    }

    struct Output {
        let createAnonymousUserResult: Observable<()>
        let loading: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let createAnonymousUserSequence: Observable<()> = input.createAnonymousUserEvent.flatMap { _ in
            return self.userAuthModel.createAnonymousUser().trackActivity(self.activity)
        }.map { user in
            LoginAccountData.uid = user.uid
        }

        return Output(createAnonymousUserResult: createAnonymousUserSequence, loading: indicator)
    }

}
