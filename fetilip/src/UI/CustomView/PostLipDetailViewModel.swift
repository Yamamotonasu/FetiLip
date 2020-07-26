//
//  PostLipDetailViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/19.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol PostLipDetailViewModelProtocol {

    func fetchUserData(documentReference: DocumentReference)

}

/**
 * PostLipDetailViewModel
 */
struct PostLipDetailViewModel: PostLipDetailViewModelProtocol {

    init(userModel: UsersModelClientProtocol) {
        self.userModel = userModel
    }

    private let userModel: UsersModelClientProtocol

    /// Relay user data.
    private let userDataRalay: PublishRelay<UserModel.Fields> = PublishRelay<UserModel.Fields>()

    private let disposeBag: DisposeBag = DisposeBag()

}

extension PostLipDetailViewModel {

    public func fetchUserData(documentReference: DocumentReference) {
        userModel.getUserData(userRef: documentReference).subscribe(onSuccess: { data in
                self.userDataRalay.accept(data)
            }, onError: { error in
                // TODO:
            }).disposed(by: disposeBag)
    }
}

extension PostLipDetailViewModel: ViewModelType {

    struct Input{
    }

    struct Output {
        let userDataObservable: Driver<UserModel.Fields>
    }

    func transform(input: Self.Input) -> Self.Output {
        return Output(userDataObservable: userDataRalay.asDriver(onErrorDriveWith: Driver.empty()))
    }
}
