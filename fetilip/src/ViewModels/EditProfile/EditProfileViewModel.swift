//
//  EditProfileViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/**
 * Edit profile view model protocol.
 */
protocol EditProfileViewModelProtocol {

}

/**
 * Edit profile screen view model.
 */
struct EditProfileViewModel: EditProfileViewModelProtocol {

    init(userModel: UsersModelClientProtocol) {
        self.userModel = userModel
    }

    let userModel: UsersModelClientProtocol

}

extension EditProfileViewModel: ViewModelType {

    struct Input {
        let profileImageObservable: Observable<UIImage?>
    }

    struct Output {
        let profileImageDriver: Driver<UIImage?>
    }

    func transform(input: Input) -> Output {
        return Output(profileImageDriver: input.profileImageObservable.asDriver(onErrorJustReturn: nil))
    }

}
