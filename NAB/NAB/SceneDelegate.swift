//
//  SceneDelegate.swift
//  NAB
//
//  Created by Trung Luân on 8/20/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let factory = DependencyContainer()
        let cityWeatherViewController = factory.makeCityWeatherViewController()
        let navigationController = UINavigationController(rootViewController: cityWeatherViewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

