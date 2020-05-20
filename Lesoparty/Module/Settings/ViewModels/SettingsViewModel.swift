//
//  SettingsViewModel.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation
import SBHelpers

extension SettingsViewModel {
    enum FirstSectionItems: String, CaseIterable {
        case intensityLabel, intensity
    }
}

class SettingsViewModel: RxTableViewModel {
    let settingsService: SettingsService
    
    init(settingsService: SettingsService) {
        self.settingsService = settingsService
    }
    
    override func setupBindings() {
        sections.accept(setupSections())
    }

    func setupSections() -> [Section] {
        let items = FirstSectionItems.allCases.map { type -> TableSectionItem in
            switch type {
            case .intensity:
                let item = ChooseIntensityTableCellViewModel(identity: "\(type)", cellType: ChooseIntentisyTableCell.self)
                item.selectedType.accept(settingsService.intensityType)
                item.selectedType.subscribe(onNext: { [weak self] type in
                    self?.settingsService.intensityType = type
                }).disposed(by: disposeBag)
                return item
            case .intensityLabel:
                let item = LabelViewModel(identity: "\(type)", cellType: LabelTableCell.self)
                item.text.accept("The period for sending notifications")
                return item
            }
        }
        
        return [Section(model: "Section", items: items)]
    }
    
    

}
