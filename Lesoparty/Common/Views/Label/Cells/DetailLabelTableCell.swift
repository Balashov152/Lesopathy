//
//  DetailLabelTableCell.swift
//  SellFashion
//
//  Created by Sergey Balashov on 20/08/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SBHelpers

protocol DetailLabelCellViewModelble: LabelViewModelble {
    var additionalText: BehaviorRelay<String?> { get }
}

class DetailLabelCellViewModel: LabelViewModel, DetailLabelCellViewModelble {
    var additionalText = BehaviorRelay<String?>(value: nil)
}

class DetailLabelTableCell: LabelTableCell {
    lazy var additionalLabel: UILabel = {
        let label = UILabel()
        label.font = .zeplin13Regular
        label.textColor = .gray174
        return label
    }()

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(additionalLabel)
        additionalLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalTo(label)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    override func setupWith(viewModel: RowViewModel) {
        super.setupWith(viewModel: viewModel)
        if let viewModel = viewModel as? DetailLabelCellViewModelble {
            viewModel.additionalText
                .bind(to: additionalLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }
}
