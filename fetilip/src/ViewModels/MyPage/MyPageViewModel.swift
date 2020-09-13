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

    init(userModel: UsersModelClientProtocol) {
        self.userModel = userModel
    }

    // MARK: - properties

    private let userModel: UsersModelClientProtocol

}

// MARK: - ViewModelType

extension MyPageViewModel: ViewModelType {

    struct Input {
        let userLoadEvent: Observable<()>
    }

    struct Output {
        let userLoadResult: Observable<UserDomainModel>
    }

    func transform(input: Input) -> Output {
        let userLoadResult = input.userLoadEvent.flatMap { _ in
            return self.userModel.getUserData(userRef: LoginAccountData.userDocumentReference).flatMap { data -> Single<UserDomainModel> in
                return Single.create { observer in
                    ApplicationFlag.shared.updateNeedProfileUpdate(false)
                    let domain = UserDomainModel.convert(data)
                    observer(.success(domain))
                    return Disposables.create()
                }
            }
        }

        return Output(userLoadResult: userLoadResult)
    }

}
