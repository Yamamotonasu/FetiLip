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

struct PostLipViewModel {

    /// DI init.
    init(postModelClient: PostModelClientProtocol,
         postStorageClient: PostsStorageClientProtocol) {
        self.postModelClient = postModelClient
        self.postStorageClient = postStorageClient
    }

    private let postModelClient: PostModelClientProtocol

    private let postStorageClient: PostsStorageClientProtocol

    // Image updated observable.
    let uploadedImage: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)

    // When Image selected, return true. Otherwise returns false.
    let imageExistsState: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

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

        input.postButtonTapEvent
            .withLatestFrom(postObservable)
            .flatMapLatest { pair -> Observable<(UIImage, String)> in
                return self.validateImageAndReviewText(pair: pair)
            }.flatMap { pair -> Observable<(StorageReference, String)> in
                return Observable.create { observer in
                    self.postStorageClient.uploadImage(uid: LoginAccountData.uid!, image: pair.0).subscribe(onSuccess: { ref in
                        observer.on(.next((ref, pair.1)))
                    }, onError: { e in
                        observer.on(.error(e))
                    }).disposed(by: self.disposeBag)
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { pair in
                self.postImage(ref: pair.0, review: pair.1)
            }).disposed(by: disposeBag)

        return Output(closeButtonHiddenEvent: imageExistsState.asDriver(onErrorJustReturn: true),
                      updatedImage: uploadedImage.asObservable())
    }

    private func validateImageAndReviewText(pair: (UIImage?, String?)) -> Observable<(UIImage, String)> {
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
    private func postImage(ref: StorageReference, review: String) {
        postModelClient.postImage(uid: LoginAccountData.uid!, review: review, imageRef: ref).subscribe(onSuccess: { _ in
            // TODO: 投稿成功時の処理
            print("投稿成功！")
        }, onError: { error in
            // TODO: 投稿失敗時の処理
            print("**\(error)")
        }).disposed(by: disposeBag)
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
