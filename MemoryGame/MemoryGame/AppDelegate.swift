//
//  AppDelegate.swift
//  MemoryGame
//
//  Created by 8 on 9.08.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = FakeLSController()
        window!.rootViewController = vc
        window?.makeKeyAndVisible()
//        setupRoot()
        return true
    }


}

