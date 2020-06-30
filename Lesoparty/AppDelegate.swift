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
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        startApp()
        return true
    }
    
    func startApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewControllerFactory.mainTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func backgroundTask(completion: @escaping () -> ()) {
        print("call backgroundTask")
        
        var task: UIBackgroundTaskIdentifier = .invalid
        task = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(task)
        }

        PushManager.shared.backgroundFetch {
            UIApplication.shared.endBackgroundTask(task)
            completion()
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        backgroundTask {
            completionHandler(.newData)
        }
    }
}

