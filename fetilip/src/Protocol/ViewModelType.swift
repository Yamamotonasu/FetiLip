//
//  ViewModelType.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/01.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

public protocol ViewModelType {

    associatedtype Input

    associatedtype Output

    /**
     * Define reaction for Input. And return outputs.
     * - Parameters:
     *  - input : Input from view.
     * - Returns: Reaction from view model.
     */
    func transform(input: Input) -> Output

}
