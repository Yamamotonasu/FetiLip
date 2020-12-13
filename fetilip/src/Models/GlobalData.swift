//
//  GlobalData.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

public protocol GlobalDataProtocol {

    var blokingUserUids: [String] { get set }

}

public struct GlobalData: GlobalDataProtocol {

    private init() {}

    static var shared: Self = GlobalData()

    public var blokingUserUids: [String] = []

}
