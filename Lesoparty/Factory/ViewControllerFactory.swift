//
//  ViewControllerFactory.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerFactory {
    static func navigationBar(root: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: root)
        nc.modalPresentationStyle = .fullScreen
        return nc
    }
    
    
    
    
    

}
