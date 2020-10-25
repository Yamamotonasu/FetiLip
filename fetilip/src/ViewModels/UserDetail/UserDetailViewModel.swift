//
//  UserDetailViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/10/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDetailViewModelProtocol {

}

public struct UserDetailViewModel {

}

extension UserDetailViewModel: ViewModelType {

    public struct Input {
        let firstLoadEvent: PublishSubject<UserDomainModelProtocol>
    }

    public struct Output {

    }

    public func transform(input: Input) -> Output {
        return Output()
    }

}
