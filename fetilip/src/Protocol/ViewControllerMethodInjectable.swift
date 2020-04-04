//
//  ViewControllerMethodInjectable.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/04/04.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/**
 * ViewControllerにViewModelの初期化を強制する為のProtocol
 */
public protocol ViewControllerMethodInjectable: class {

    /// ViewController内にDependency構造体を定義する
    /// Dependency内にViewController内に初期化したいPropertyを定義する]
    associatedtype Dependency

    /// Dependency構造体のプロパティを使ってViewControllerのプロパティを初期化する為の関数
    func inject(with dependency: Dependency)

    /// ViewModelProtocol又はViewModelの型をtypealiasで指定しておく
    associatedtype ViewModel

    /// ViewModel
    var viewModel: ViewModel? { get }

}
