//
//  DateFormatter+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/02.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

// Reference: https://qiita.com/rinov/items/bff12e9ea1251e895306
extension DateFormatter {

    enum Template: String {
        case date = "yMd"     // 2017/1/1
        case time = "Hms"     // 12:39:22
        case full = "yMdkHms" // 2017/1/1 12:39:22
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
    }

    func setTemplate(_ template: Template) {
        // optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }

}
