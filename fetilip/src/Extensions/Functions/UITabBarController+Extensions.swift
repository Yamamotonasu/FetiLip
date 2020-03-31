//
//  UITabBarController+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/31.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

extension UITabBarController {

    public enum TabViewControllerIndex: Int {
        case postList = 0
        case myPage = 1
    }

    private func findViewController<T: UIViewController>() -> T? {
        for vc in (viewControllers ?? []) {
            if let ret = (vc as? UINavigationController)?.viewControllers.first as? T {
                return ret
            } else if let ret = (vc as? T) {
                return ret
            }
        }
        return nil
    }

    /// 一覧画面のインスタンス取得
    var postListViewController: PostListViewController? {
        return findViewController()
    }

    /// マイページのインスタンス取得
    var myPageViewController: MyPageViewController? {
        return findViewController()
    }

    /// タブの一番左に配置しているViewController
    var firstViewController: UIViewController? {
        return self.viewControllers?.first
    }

    /// タブの左から2番目に配置しているViewController
    var secondViewController: UIViewController? {
        // 配列外参照対策
        if (self.viewControllers?.count ?? 0) < 2 { return nil }
        return self.viewControllers?[2]
    }

}
