//
//  EditProfileDetailViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditProfileDetailViewModelProtocol {

}

struct EditProfileDetailViewModel: EditProfileDetailViewModelProtocol {

    init(userModelClient: UsersModelClientProtocol) {
        self.userModelClient = userModelClient
    }

    let userModelClient: UsersModelClientProtocol

    private let maxUserNameLength = 12

}

extension EditProfileDetailViewModel {

    private func updateEvent(editProfileDetailType: EditProfileDetailType, userName: String?) -> Single<()>{
        switch editProfileDetailType {
        case .userName:
            return validateUserName(userName: userName).flatMap { name -> Single<()> in
                return self.userModelClient.updateUserName(uid: LoginAccountData.uid!, userName: name)
            }
        default:
            return Observable.empty().asSingle()
        }
    }

    private func validateUserName(userName: String?) -> Single<String> {
        return Single.create { observer in
            if let name = userName {
                if name.count > self.maxUserNameLength {
                    observer(.error(ValidationError.tooLongCharacters(maximum: self.maxUserNameLength)))
                } else {
                    observer(.success(name))
                }
            } else {
                observer(.error(ValidationError.emptyInput))
            }
            return Disposables.create()
        }
    }

}

extension EditProfileDetailViewModel: ViewModelType {

    struct Input {
        let textFieldObservable: Observable<String?>
        let updateProfileEvent: Observable<EditProfileDetailType>
    }

    struct Output {
        let updateResult: Observable<()>
    }

    func transform(input: Input) -> Output {
        let combine = Observable.combineLatest(input.textFieldObservable, input.updateProfileEvent) {
            (text: $0, type: $1)
        }

        let updateSequence = combine.retry().flatMap { pair -> Single<()> in
            return self.updateEvent(editProfileDetailType: pair.type, userName: pair.text)
        }

        return Output(updateResult: updateSequence)
    }

}
