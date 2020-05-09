//
//  ViewControllerMethodInjectable.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * Protocol for implementing method injection of ViewController.
 * - Note:This protocol is supposed to be used with ViewController generator class.
 */
public protocol ViewControllerMethodInjectable: class {

    /// Define the parameter that depend on the initialization of the ViewController.
    associatedtype Dependency

    /// Function that actually performs method injection.
    func inject(with dependency: Dependency)

}
