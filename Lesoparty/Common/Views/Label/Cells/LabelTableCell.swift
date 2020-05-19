//
//  LabelTableCell.swift
//  SellFashion
//
//  Created by Sergey on 19/07/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SBHelpers

protocol AttributedLabelViewModelble: RowViewModel {
    var attributedText: BehaviorRelay<NSAttributedString?> { get }
}

class AttributedLabelViewModel: TableSectionItem, AttributedLabelViewModelble {
    var attributedText = BehaviorRelay<NSAttributedString?>(value: nil)
}

protocol LabelViewModelble: RowViewModel {
    var text: BehaviorRelay<String?> { get }
}

class LabelViewModel: TableSectionItem, LabelViewModelble {
    var text = BehaviorRelay<String?>(value: nil)
}

class LabelTableCell: RxTableViewCellJ, RxViewModable {
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .zeplin14Regular
        label.textColor = .gray34
        return label
    }()

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.top.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().priority(.medium)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(20)
        }
    }

    func setupWith(viewModel: RowViewModel) {
        if let viewModel = viewModel as? LabelViewModelble {
            viewModel.text
                .bind(to: label.rx.text).disposed(by: disposeBag)
        }

        if let viewModel = viewModel as? AttributedLabelViewModelble {
            viewModel.attributedText
                .bind(to: label.rx.attributedText).disposed(by: disposeBag)
        }
    }
}
