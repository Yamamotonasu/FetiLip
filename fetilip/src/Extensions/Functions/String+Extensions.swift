//
//  String+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

extension String {

    /// Convert from <br/> to \n in self.
    var replacedLineFeedCode: String? {
        self.replacingOccurrences(of: "<br/>", with: "\n")
    }

}
