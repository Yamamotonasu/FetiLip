//
//  ReviewValidation.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/30.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

typealias ReviewValidator = ValidationContainer<(UIImage?, String?), InvalidReview>

enum InvalidReview: InvalidStatus, Error {

    case imageNotFound

    case tooLong(maxCount: Int)

}

extension InvalidReview: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .imageNotFound:
            return R._string.validation.reviewImageNotFound
        case .tooLong(let maxCount):
            return R._string.validation.tooLongReview(maximum: maxCount)
        }
    }

}

extension ValidationContainer where Target == (UIImage?, String?), Invalid == InvalidReview {

    func imageNotEmpty() -> Self {
        return guarantee({ (image, review) in
            if let _ = image {
                return true
            } else {
                return false
            }
        }, otherwise: .imageNotFound)
    }

    func lessThanDigits() -> Self {
        let maxDigits = ValidationCharacters.review.max
        return guarantee({ (image, review) in
            if let input = review {
                return  input.count <= maxDigits
            } else {
                return false
            }
        }, otherwise: .tooLong(maxCount: maxDigits))
    }

}
