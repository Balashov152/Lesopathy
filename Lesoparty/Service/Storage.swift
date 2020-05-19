//
//  Storage.swift
//  SellFashion
//
//  Created by Sergey on 18/07/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import Foundation
import UIKit

enum StorageKeys: String, CaseIterable {
    case key
}

struct Storage {
    static let defaults = UserDefaults.standard

    static func clear() {
        StorageKeys.allCases.forEach {
            defaults.removeObject(forKey: $0.rawValue)
            print("Storage", $0.rawValue, defaults.object(forKey: $0.rawValue) ?? "non object")
            defaults.synchronize()
        }
        CoreDataService.shared.deleteCache()

        UIApplication.shared.unregisterForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
