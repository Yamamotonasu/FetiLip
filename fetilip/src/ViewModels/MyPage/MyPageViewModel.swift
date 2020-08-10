//
//  MyPageViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

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

extension MyPageViewModel: ViewModelType {

    struct Input {
        let userLoadEvent: Observable<()>
    }

    struct Output {
//        let userLoadResult: Observable<()>
    }

    func transform(input: Input) -> Output {
//        input.userLoadEvent.flatMap { _ -> Observable<UserDomainModel> in
//            return self.userModel.getUserData(userRef: LoginAccountData.userDocumentReference)
//        }
        return Output()
    }

}
