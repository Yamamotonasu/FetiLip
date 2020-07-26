//
//  PostLipViewModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/10.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage
import NVActivityIndicatorView

struct PostLipViewModel {

    /// DI init.
    init(postModelClient: PostModelClientProtocol,
         postStorageClient: PostsStorageClientProtocol) {
        self.postModelClient = postModelClient
        self.postStorageClient = postStorageClient
        indicator = activity.asObservable()
    }

    private let postModelClient: PostModelClientProtocol

    private let postStorageClient: PostsStorageClientProtocol

    /// Image updated observable.
    let uploadedImage: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)

    /// When Image selected, return true. Otherwise returns false.
    let imageExistsState: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    /// Post request result notification.
    /// return true: success post request, return false: failed post request.
    private let resultPostSubject: PublishSubject<Bool> = PublishSubject<Bool>()

    let activity: ActivityIndicator = ActivityIndicator()

    /// Bool loading state.
    let indicator: Observable<Bool>

    let disposeBag: DisposeBag = DisposeBag()
    
}

extension PostLipViewModel: ViewModelType {

    struct Input {
        // Delete image action.
        let deleteButtonTapEvent: Observable<Void>
        // Post button action.
        let postButtonTapEvent: Observable<Void>
        // Reviewing text.
        let postLipReviewText: Observable<String?>
    }

    struct Output {
        // Bind close button isHidden. If updated image == nil, return true
        let closeButtonHiddenEvent: Driver<Bool>
        // Image observable
        let updatedImage: Observable<UIImage?>

        let postResult: Observable<()>

        let indicator: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        input.deleteButtonTapEvent
            .withLatestFrom(self.uploadedImage)
            .subscribe(onNext: { image in
                self.imageExistsState.accept(image == nil)
                self.uploadedImage.accept(nil)
            }).disposed(by: disposeBag)

        let postObservable = Observable.combineLatest(self.uploadedImage, input.postLipReviewText) {
            (uploadedImage: $0, reviewText: $1)
        }

        let postSequence = input.postButtonTapEvent
            .printDebug()
            .withLatestFrom(postObservable)
            .flatMapLatest { pair -> Observable<(UIImage, String)> in
                return self.validateImageAndReviewText(pair: pair)
            }.flatMapLatest { pair -> Observable<(StorageReference, String)> in
                return self.postStorageClient.uploadImage(uid: LoginAccountData.uid!, image: pair.0).flatMap { s -> Single<(StorageReference, String)>in
                        return Single.create { observer in
                            observer(.success((s, pair.1)))
                            return Disposables.create()
                        }
                    }.trackActivity(self.activity)
            }.flatMapLatest { pair -> Observable<()> in
                return self.postImage(ref: pair.0, review: pair.1).trackActivity(self.activity)
            }.retry()

        return Output(closeButtonHiddenEvent: imageExistsState.asDriver(onErrorJustReturn: true),
                      updatedImage: uploadedImage.asObservable(),
                      postResult: postSequence,
                      indicator: indicator)
    }

    /// Validate posted images and reviews.
    private func
        validateImageAndReviewText(pair: (UIImage?, String?)) -> Observable<(UIImage, String)> {
        return Observable.create { observer in
            guard let image = pair.0 else {
                observer.on(.error(PostValidateError.imageNotFound))
                return Disposables.create()
            }

            // とりあえず雑に500文字以下でバリデーション
            guard let text = pair.1, text.count < 500 else {
                observer.on(.error(PostValidateError.excessiveNumberOfInputs))
                return Disposables.create()
            }

            observer.on(.next((image, text)))

            return Disposables.create()
        }

    }

}

// MARK: Private functions

extension PostLipViewModel {

    /// Uploaded lip image.
    private func postImage(ref: StorageReference, review: String) -> Single<()> {
        return postModelClient.postImage(uid: LoginAccountData.uid!, review: review, imageRef: ref)
    }

}

fileprivate enum PostValidateError: Error {

    case imageNotFound

    case excessiveNumberOfInputs

    var message: String {
        switch self {
        case .imageNotFound:
            return R._string.error.imageNotFound
        case .excessiveNumberOfInputs:
            return R._string.error.excessiveNumberOfInputs
        }
    }

}
