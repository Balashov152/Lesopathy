//
//  ChooseIntensityTableCell.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import SBHelpers

class ChooseIntensityTableCellViewModel: TableSectionItem {
    var selectedType = BehaviorRelay<SettingsModel.TypeIntensity>(value: .average)
}

class ChooseIntentisyTableCell: RxTableViewCellJ, RxViewModable {
    
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        SettingsModel.TypeIntensity.allCases
            .forEach { segment.insertSegment(withTitle: $0.title, at: $0.rawValue, animated: false)}
        return segment
    }()
    
    override func commonInit() {
        super.commonInit()
        contentView.addSubview(segment)
        segment.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    
    func setupWith(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? ChooseIntensityTableCellViewModel else {
            return
        }
        viewModel.selectedType.map { $0.rawValue }
            .bind(to: segment.rx.selectedSegmentIndex).disposed(by: disposeBag)
        
        segment.rx.selectedSegmentIndex
            .map(SettingsModel.TypeIntensity.init).unwrap()
            .bind(to: viewModel.selectedType).disposed(by: disposeBag)
    }
    
}
