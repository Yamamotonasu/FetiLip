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
        indicator = self.activity.asObservable()
    }

    // MARK: - Properties

    private let userModelClient: UsersModelClientProtocol

    private let userAuthModel: UserAuthModelProtocol

    private let activity: ActivityIndicator = ActivityIndicator()

    private let indicator: Observable<Bool>

    private let maxUserNameLength = 12

}

extension EditProfileDetailViewModel {

    private func updateEvent(editProfileDetailType: EditProfileDetailType, input: String?, password: String = "") -> Single<()>{
        switch editProfileDetailType {
        case .userName:
            return validateUserName(userName: input).flatMap { name -> Single<()> in
                return self.userModelClient.updateUserName(uid: LoginAccountData.uid!, userName: name)
            }
        case .email(let defaults):
            return self.userAuthModel.reauthenticateUser(email: defaults, password: password).flatMap { _ in
                self.validateEmail(email: input).flatMap { email in
                    self.userAuthModel.updateUserEmail(email: email)
                }
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
        let passwordTextObservable: Observable<String>
        let updateProfileEvent: Observable<EditProfileDetailType>
        let saveProfileEvent: Observable<()>
    }

    struct Output {
        let updateResult: Observable<()>
        let indicator: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let combine = Observable.combineLatest(input.textFieldObservable, input.updateProfileEvent, input.passwordTextObservable) {
            (input: $0, type: $1, password: $2)
        }

        let updateSequence = input.saveProfileEvent.asObservable().withLatestFrom(combine).flatMapLatest { stream -> Observable<()> in
            return self.updateEvent(editProfileDetailType: stream.type, input: stream.input, password: stream.password).trackActivity(self.activity)
        }.retry()

        return Output(updateResult: updateSequence, indicator: indicator)
    }

}
