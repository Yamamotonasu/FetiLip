//
//  FirestoreEntity.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/30.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

public protocol FirestoreEntity {

    var createdAt: Timestamp { get }

    var updatedAt: Timestamp { get }

}
