//
//  SceneDelegate.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 20/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()

    }

}

