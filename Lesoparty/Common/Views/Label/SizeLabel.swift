//
//  SizeLabel.swift
//  SellFashion
//
//  Created by Sergey Balashov on 03/10/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import UIKit

class SizeLabel: PaddingLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        numberOfLines = 1
        contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        font = .zeplin13Heavy
        textColor = .gray34
        backgroundColor = .gray243
        clipsToBounds = true
        textAlignment = .center

        snp.makeConstraints { make in
            let margins = (contentInset?.top ?? 0) + (contentInset?.bottom ?? 0)
            make.height.equalTo(font.lineHeight + margins)
            make.width.greaterThanOrEqualTo(snp.height)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
