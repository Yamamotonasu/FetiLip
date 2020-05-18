//
//  FirestoreRequest.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/05/18.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Protocol for communicating with firestore.
 */
public protocol FirestoreRequest {

    /// Firestore schema.
    associatedtype Fields

    /// Request parameters to firestore.
    var parameters: Parameters { get }

}
