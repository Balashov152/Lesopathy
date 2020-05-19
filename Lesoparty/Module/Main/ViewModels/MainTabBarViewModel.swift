//
//  MainTabBarViewModel.swift
//  SellFashion
//
//  Created by Sergey Balashov on 23.12.2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftPermissionManager
import UIKit

class MainTabBarViewModel: RxViewModel {
    let pushManager = PushManager.shared
    var isNeedNotificationCheck = true

    override func setupBindings() {
        super.setupBindings()
        pushManager.updateBadge.onNext(())
    }

    func checkAndRequestNotification() {
        guard isNeedNotificationCheck else { return }

        let permission = PermissionManager()
        permission.checkPermission(type: .notification, createRequestIfNeed: true, denied: {
            DispatchQueue.main.async {
                print("checkAndRequestNotification is denied")
                let localized = PermissionManager.LocalizedAlert(title: "Not work notification", subtitle: "turn on notification",
                                                                 openSettings: "Open settings", cancel: "Cancel")
                PermissionManager().openSettings(type: .notification, localized: localized)
            }
        }, access: {
            print("checkAndRequestNotification is access")
//            PushManager.shared.updatePushToken()
        })

        isNeedNotificationCheck = false
    }
}
