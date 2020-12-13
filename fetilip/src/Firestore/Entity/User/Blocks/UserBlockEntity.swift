//
//  UserBlockEntity.swift
//  fetilip
//
//  Created by yuu yamamoto on 2020/12/13.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * User blocks
 *  - Other users can get information
 */
public struct UserBlockEntity: Codable {
    
    public let targetUid: String
    
    public let createdAt: Timestamp
    
    public let updatedAt: Timestamp
    
    enum Key: String, CodingKey {
        
        case targetUid
        
        case createdAt
        
        case updatedAt

    }

}
