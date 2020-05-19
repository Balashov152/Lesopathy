//
//  SettingsViewController.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation

class SettingsViewController<ViewModel: SettingsViewModel>: RxTableViewControllerJ<SettingsViewModel> {
    
    // word for push ?
    // how many push ?
    
    // apple watch
    
    override func loadView() {
        super.loadView()
        title = "Settings"
        
        tableView.register(cell: LabelTableCell.self)
        tableView.register(cell: ChooseIntentisyTableCell.self)
    }
    
}
