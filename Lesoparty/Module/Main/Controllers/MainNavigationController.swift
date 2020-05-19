//
//  MainNavigationController.swift
//  PickMeUp
//
//  Created by Sergey on 04.07.2018.
//  Copyright © 2018 MediaStreamGroup. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit

class MainNavigationController: UINavigationController {
    let isHideTabBarControllers: [UIViewController.Type] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self
    }
    
    // MARK: Tab Bar hide

    private func checkTapBarHide(viewController: UIViewController) {
        let isHide = isHideTabBarControllers.contains(where: { $0 == type(of: viewController) })
        
        UIView.animate(withDuration: 0.1, animations: { [weak viewController] in
            if !isHide {
                viewController?.tabBarController?.tabBar.isHidden = false
            }
            viewController?.tabBarController?.tabBar.alpha = isHide ? 0 : 1
        }) { [weak viewController] _ in
            viewController?.tabBarController?.tabBar.isHidden = isHide
        }
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.contains(viewController) {
            popToViewController(viewController, animated: true)
        }
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
//        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        checkTapBarHide(viewController: viewController)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
//        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.rx.viewDidAppear.subscribe(onNext: { [weak self, weak viewController] _ in
            if let viewController = viewController {
                self?.checkTapBarHide(viewController: viewController)
            }
        }).disposed(by: rx.disposeBag)
    }
}
