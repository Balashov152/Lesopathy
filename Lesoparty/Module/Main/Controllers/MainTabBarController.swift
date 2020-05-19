//
//  MainTabBarController.swift
//  BubbleComics
//
//  Created by Sergey Balashov on 17/06/2019.
//  Copyright © 2019 Bubble. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIApplication {
    var tabBarController: MainTabBarController? {
        UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
    }
}


class MainTabBarController: UITabBarController {
    var viewModel = MainTabBarViewModel()

    convenience init(indexes: [IndexType]) {
        self.init(nibName: nil, bundle: nil)
        setViewControllers(indexes.map { ViewControllerFactory.tabBarChildController(on: $0) }, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .gray255
        tabBar.barTintColor = .gray255
        delegate = self
        
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkAndRequestNotification()
    }

    private func setupBindings() {}
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

extension UITabBarController {
    enum IndexType: Int, CaseIterable {
        case words, settings
    }

    func showIndex(index: IndexType) {
        if selectedIndex == index.rawValue {
            (selectedViewController as? UINavigationController)?.popToRootViewController(animated: true)
        } else {
            selectedIndex = index.rawValue
        }
    }

    func setBadge(badge: Int, for index: IndexType) {
        tabBar.items?[safe: index.rawValue]?.badgeValue = badge == 0 ? nil : "\(badge)"
    }
}

extension UITabBarItem {
    convenience init(type: UITabBarController.IndexType) {
        switch type {
        case .words:
            self.init(tabBarSystemItem: UITabBarItem.SystemItem.bookmarks, tag: type.rawValue)
        case .settings:
            self.init(tabBarSystemItem: UITabBarItem.SystemItem.more, tag: type.rawValue)
        }
    }
}
