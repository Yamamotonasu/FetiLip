//
//  GlobalData.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

public protocol GlobalDataProtocol {

    var blokingUserUids: [String] { get }

}

public struct GlobalData: GlobalDataProtocol {

    private init() {}

    static let shared: Self = GlobalData()

    public let blokingUserUids: [String] = []

}
