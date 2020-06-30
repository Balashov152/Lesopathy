//
//  WordTableCell.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 20.05.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SBHelpers

class WordTableCellViewModel: LabelViewModel {
    var progress = BehaviorRelay<Double>(value: 0.0)
}

class WordTableCell: LabelTableCell {
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        // TODO: Set colors
        progressView.progressTintColor = .appPurple
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    override func commonInit() {
        super.commonInit()
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    override func setupWith(viewModel: RowViewModel) {
        super.setupWith(viewModel: viewModel)
        if let viewModel = viewModel as? WordTableCellViewModel {
            viewModel.progress.map(Float.init)
                .bind(to: progressView.rx.progress).disposed(by: disposeBag)
        }
    }
}
