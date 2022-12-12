//
//  SceneDelegate.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 28.11.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let alertFactory = CountriesAlertViewFactory()
        let service = CountryService()
        let dataSource = CountriesViewDataSource()
        let presentor = CountriesPresentor(service: service,
                                           dataSource: dataSource
        )
        let countiesViewController = CountriesViewController(alertFactory: alertFactory, output: presentor)
        presentor.view = countiesViewController
        let rootNavigationController = UINavigationController(rootViewController: countiesViewController)
        window.rootViewController = rootNavigationController
        self.window = window
        window.makeKeyAndVisible()
//        let viewController = CountriesViewController()
//
//

    }
}

