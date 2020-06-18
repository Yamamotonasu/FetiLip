//
//  DomainModelProtocol.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/16.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Protocol that convert input entity to output domain model
 */
protocol DomainModelProtocol {

    /// Inut entity. (must conform FirestoreDatabaseCollection)
    associatedtype Input: FirestoreDatabaseCollection

    /// Output entity. (must conform self protocol)
    associatedtype Output: DomainModelProtocol

    /// Function convert input entity to output domain model.
    static func convert(_ model: Input.FieldType) -> Output

}
