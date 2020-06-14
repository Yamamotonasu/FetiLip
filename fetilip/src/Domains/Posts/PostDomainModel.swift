//
//  PostDomainModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/14.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

struct PostDomainModel: DomainModelProtocol {

    typealias Input = PostModel

    typealias Output = Self

    /// Post image.
    let image: UIImage?

    static func convert(_ model: PostModel.Fields) -> Self {
        if let base64 = Data(base64Encoded: model.image) {
            let image = UIImage(data: base64)
            return self.init(image: image)
        }
        // TODO: Failed read image handler.
        return self.init(image: nil)
    }

}

protocol DomainModelProtocol {

    associatedtype Input: FirestoreDatabaseCollection

    associatedtype Output: DomainModelProtocol

    static func convert(_ model: Input.FieldType) -> Output

}
