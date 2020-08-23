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

    init(userModelClient: UsersModelClientProtocol, userAuthModel: UserAuthModelProtocol) {
        self.userModelClient = userModelClient
        self.userAuthModel = userAuthModel
    }

    private let userModelClient: UsersModelClientProtocol

    private let userAuthModel: UserAuthModelProtocol

    private let maxUserNameLength = 12

}

extension EditProfileDetailViewModel {

    private func updateEvent(editProfileDetailType: EditProfileDetailType, input: String?) -> Single<()>{
        switch editProfileDetailType {
        case .userName:
            return validateUserName(userName: input).flatMap { name -> Single<()> in
                return self.userModelClient.updateUserName(uid: LoginAccountData.uid!, userName: name)
            }
        case .email:
            return validateEmail(email: input).flatMap { email -> Single<()> in
                self.userAuthModel.updateUserEmail(email: email)
            }
        default:
            return Observable.empty().asSingle()
        }
    }

    private func validateUserName(userName: String?) -> Single<String> {
        return Single.create { observer in
            // TODO: Use validate container.
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

    private func validateEmail(email: String?) -> Single<String> {
        return Single.create { observer in
            let validator = EmailValidator.validate(email) { $0.isNotEmpty().validFormat() }
            switch validator {
            case .invalid(let status):
                observer(.error(status))
            case .valid:
                observer(.success(email!))
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

        let updateSequence = input.updateProfileEvent.retry().withLatestFrom(combine).flatMap { pair -> Single<()> in
            return self.updateEvent(editProfileDetailType: pair.type, input: pair.text)
        }

        return Output(updateResult: updateSequence)
    }

}
