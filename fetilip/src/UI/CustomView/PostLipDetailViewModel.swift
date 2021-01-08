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

}

/**
 * PostLipDetailViewModel
 */
struct PostLipDetailViewModel: PostLipDetailViewModelProtocol {

    init(userModel: UsersModelClientProtocol, postModel: PostModelClientProtocol, violationModel: ViolationReportClientProtocol) {
        self.userModel = userModel
        self.postModel = postModel
        self.violationModel = violationModel
        self.indicator = activity.asObservable()
    }

    // MARK: - Model
    private let userModel: UsersModelClientProtocol

    private let postModel: PostModelClientProtocol

    private let violationModel: ViolationReportClientProtocol

    // MARK: - Rx

    private let activity: ActivityIndicator = ActivityIndicator()

    private let indicator: Observable<Bool>

}

extension PostLipDetailViewModel: ViewModelType {

    struct Input {
        let firstLoadEvent: Observable<PostDomainModel>
        let deleteEvent: PublishSubject<PostDomainModel>
        let violationReportEvent: PublishSubject<PostDomainModel>
    }

    struct Output {
        let userDataObservable: Observable<UserDomainModel>
        let deleteResult: Observable<DocumentReference>
        let sendViolationReportResult: Observable<()>
        let loading: Observable<Bool>
    }

    func transform(input: Self.Input) -> Self.Output {
        let userLoadSequence = input.firstLoadEvent.flatMapLatest { postDomain -> Observable<UserModel.FieldType> in
            return self.userModel.getUserData(userRef: postDomain.userRef).asObservable()
        }.flatMapLatest { userEntity -> Single<UserDomainModel> in
            return Single.create { observer in
                observer(.success(UserDomainModel.convert(userEntity)))
                return Disposables.create()
            }
        }.share()

        // TODO: Fource unwrap
        let deleteSequence: Observable<DocumentReference> = input.deleteEvent.flatMapLatest { postDomainModel in
            return self.postModel.deletePost(targetReference: postDomainModel.documentReference!).trackActivity(self.activity)
        }

        // TODO: Fource unwrap
        let sendViolationReportSequence: Observable<()> = input.violationReportEvent.flatMapLatest { postDomainModel in
            return self.violationModel.sendViolationReport(targetUid: postDomainModel.userUid, targetPostId: postDomainModel.documentReference!.documentID, targetImageRef: postDomainModel.imageRef).trackActivity(self.activity)
        }

        return Output(userDataObservable: userLoadSequence, deleteResult: deleteSequence, sendViolationReportResult: sendViolationReportSequence, loading: indicator)
    }

}
