//
//  SceneDelegate.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/15.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        let tab = GlobalTabBarControllerGenerator.generate()
        window.rootViewController = tab
    }

}
