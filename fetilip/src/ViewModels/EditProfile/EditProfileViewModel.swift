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
import Firebase

/**
 * Edit profile view model protocol.
 */
protocol EditProfileViewModelProtocol {

}

/**
 * Edit profile screen view model.
 */
struct EditProfileViewModel: EditProfileViewModelProtocol {

    // MARK: - init

    init(userModel: UsersModelClientProtocol, userStorageClient: UsersStorageClientProtocol, userAuthModel: UserAuthModelProtocol) {
        self.userModel = userModel
        self.userStorageClient = userStorageClient
        self.userAuthModel = userAuthModel
        self.indicator = activity.asObservable()
    }

    // MARK: - Properties

    private let userModel: UsersModelClientProtocol

    private let userStorageClient: UsersStorageClientProtocol

    private let userAuthModel: UserAuthModelProtocol

    private let activity: ActivityIndicator = ActivityIndicator()

    // MARK: - Rx

    private let indicator: Observable<Bool>

    private let emailSubject: BehaviorSubject<String?> = BehaviorSubject<String?>(value: nil)

    private let registerHiddenSubject: BehaviorSubject = BehaviorSubject<Bool>(value: true)

}

extension EditProfileViewModel: ViewModelType {

    struct Input {
        let updateProfileImageEvent: Observable<()>
        let profileImageObservable: Observable<UIImage?>
    }

    struct Output {
        let updateUserImageResult: Observable<()>
        let profileImageDriver: Driver<UIImage?>
        let emailDriver: Driver<String?>
        let registerButtonDriver: Driver<Bool>
        let loading: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let updateUserImageSequence = input.updateProfileImageEvent
            .withLatestFrom(input.profileImageObservable)
            .retry()
            .flatMap { image -> Single<UIImage> in
                return self.validateProfileImage(image: image)
            }.flatMap { image -> Observable<StorageReference> in
                return self.userStorageClient.uploadImage(uid: LoginAccountData.uid!, image: image).flatMap { s -> Single<StorageReference> in
                    return Single.create { observer in
                        observer(.success(s))
                        return Disposables.create()
                    }
                }.trackActivity(self.activity)
        }.flatMap { storageRef -> Observable<()> in
            return self.userModel.updateUserProfileReference(userRef: UserModel.makeDocumentRef(id: LoginAccountData.uid!), storagePath: storageRef.fullPath).trackActivity(self.activity)
        }

        let _ = userAuthModel.checkLogin().subscribe(onSuccess: { user in
            self.emailSubject.onNext(user.email)
            self.registerHiddenSubject.onNext(!user.isAnonymous)
        })

        return Output(updateUserImageResult: updateUserImageSequence,
                      profileImageDriver: input.profileImageObservable.asDriver(onErrorJustReturn: nil),
                      emailDriver: emailSubject.asDriver(onErrorJustReturn: ""),
                      registerButtonDriver: registerHiddenSubject.asDriver(onErrorJustReturn: true),
                      loading: indicator)
    }

}

// MARK: - Functions

extension EditProfileViewModel {

    private func validateProfileImage(image: UIImage?) -> Single<UIImage> {
        return Single.create { observer in
            if let i = image {
                observer(.success(i))
            } else {
                observer(.error(EditProfileViewModelError.imageNotFount(message: R._string.error.updateImageNotFound)))
            }
            return Disposables.create()
        }
    }

}

enum EditProfileViewModelError: Error {

    case imageNotFount(message: String)

}
