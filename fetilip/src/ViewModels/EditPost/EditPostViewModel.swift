//
//  EditPostViewModel.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/10.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import Foundation

protocol EditPostViewModelProtocol {

}

public struct EditPostViewModel: EditPostViewModelProtocol {

    public init() {
    }

}

extension EditPostViewModel: ViewModelType {

    public struct Input {

    }

    public struct Output {

    }

    public func transform(input: Input) -> Output {
        return Output()
    }

}
