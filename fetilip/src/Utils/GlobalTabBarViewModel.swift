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

    init(userAuthModel: UserAuthModelProtocol) {
        self.userAuthModel = userAuthModel
    }

    let userAuthModel: UserAuthModelProtocol

}

extension GlobalTabBarViewModel: ViewModelType {

    struct Input {
        let checkLoginEvent: PublishRelay<()>
    }

    struct Output {
        let checkLoginResult: Observable<()>
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
        return Output(checkLoginResult: checkLoginSequence)
    }

}
