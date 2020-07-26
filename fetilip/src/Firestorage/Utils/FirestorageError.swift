//
//  FirestorageError.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/19.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Firestorage related error enum.
 */
public enum FirestorageError: Error {

    case failedUploadImage(_ message: String)

    case failedGetImage(_ message: String)

}
