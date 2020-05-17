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

struct PostLipViewModel {

    // Image updated observable.
    let updatedImage: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)

    // When Image selected, return true. Otherwise returns false.
    let imageExistsState: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)

    let disposeBag: DisposeBag = DisposeBag()
    
}

extension PostLipViewModel: ViewModelType {

    struct Input {
        // Delete image action.
        let deleteButtonTapEvent: Observable<Void>
        // Post button action.
        let postButtonTapEvent: Observable<Void>
    }

    struct Output {
        // Bind close button isHidden. If updated image == nil, return true
        let closeButtonHiddenEvent: Driver<Bool>
        // Image observable
        let updatedImage: Observable<UIImage?>
    }

    func transform(input: Input) -> Output {
        input.deleteButtonTapEvent
            .withLatestFrom(self.updatedImage)
            .subscribe(onNext: { image in
                self.imageExistsState.accept(image == nil)
                self.updatedImage.accept(nil)
            }).disposed(by: disposeBag)

        input.postButtonTapEvent
            .withLatestFrom(self.updatedImage)
            .flatMap { $0.flatMap(Observable.just) ?? Observable.empty() }
            .subscribe(onNext: { image in
                self.postImage(with: image)
            }).disposed(by: disposeBag)

        return Output(closeButtonHiddenEvent: imageExistsState.asDriver(onErrorJustReturn: true),
                      updatedImage: updatedImage.asObservable())
    }

}

// MARK: Private functions

extension PostLipViewModel {

    private func postImage(with image: UIImage) {

    }
}
