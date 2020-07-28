//
//  PostListSectionDomainModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/28.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxDataSources

struct PostListSectionDomainModel {

    var items: [Item]

}

extension PostListSectionDomainModel: SectionModelType {

    typealias Item = PostDomainModel

    init(original: PostListSectionDomainModel, items: [PostDomainModel]) {
        self = original
        self.items = items
    }

}
