//
//  ViewControllerFactory+Main.swift
//  SellFashion
//
//  Created by Sergey Balashov on 09.01.2020.
//  Copyright © 2020 Sellfashion. All rights reserved.
//

import Foundation
import UIKit

extension ViewControllerFactory {
    static func wordsViewController() -> WordsViewController<WordsViewModel> {
        return WordsViewController<WordsViewModel>(viewModel: WordsViewModel())
    }
    
    static func settingsViewController() -> SettingsViewController<SettingsViewModel> {
        let viewModel = SettingsViewModel(settingsService: SettingsService())
        return SettingsViewController<SettingsViewModel>(viewModel: viewModel)
    }

    static func mainTabBarController() -> MainTabBarController {
        return MainTabBarController(indexes: MainTabBarController.IndexType.allCases)
    }

    static func tabBarChildController(on index: MainTabBarController.IndexType) -> UINavigationController {
        let vc: UINavigationController
        switch index {
        case .words:
            vc = navigationBar(root: wordsViewController())
        case .settings:
            vc = navigationBar(root: settingsViewController())
        }
        vc.tabBarItem = UITabBarItem(type: index)
        return vc
    }
}
