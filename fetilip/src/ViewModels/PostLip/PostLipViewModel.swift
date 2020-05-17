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

    let imageExistsState: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    
}

extension PostLipViewModel: ViewModelType {

    struct Input {
        // Delete image action.
        let deleteButtonTap: Observable<Void>
    }

    struct Output {
        // Bind close button isHidden. If updated image == nil, return true
        let closeButtonHiddenEvent: Driver<Bool>
        // Image observable
        let updatedImage: Observable<UIImage?>
    }

    func transform(input: Input) -> Output {
        let _ = input.deleteButtonTap.withLatestFrom(self.updatedImage).subscribe(onNext: { image in
            self.imageExistsState.accept(image == nil)
            self.updatedImage.accept(nil)
        })
        return Output(closeButtonHiddenEvent: imageExistsState.asDriver(onErrorJustReturn: true),
                      updatedImage: updatedImage.asObservable())
    }

}
