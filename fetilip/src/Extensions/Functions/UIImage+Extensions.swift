//
//  UIImage+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    public enum JPEGQuality {
        case lowest
        case low
        case medium
        case high
        case highest
        case custom(_ quality: CGFloat)

        var value: CGFloat {
            switch self {
            case .lowest             : return 0
            case .low                : return 0.25
            case .medium             : return 0.5
            case .high               : return 0.75
            case .highest            : return 1
            case .custom(let quality): return quality
            }
        }
    }

    public func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.value)
    }

    var base64: String? {
        guard let base64String = jpeg(.medium)?.base64EncodedString() else {
            return nil
        }
        return "data:image/jpeg;base64," + base64String
    }

}
