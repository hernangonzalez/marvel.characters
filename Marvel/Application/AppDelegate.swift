//
//  AppDelegate.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit
import MarvelKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let model = MainViewViewModel(source: CharacterQuery(),
                                      stars: StarStore(.standard))
        let images = ImageLoader()
        let main = MainViewController(model: model, loader: images)
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: main)
        window?.makeKeyAndVisible()
        return true
    }
}
