//
//  AppDelegate.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 14.01.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startApp()
        return true
    }
    
    func startApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewControllerFactory.mainTabBarController()
        window?.makeKeyAndVisible()
    }
}

