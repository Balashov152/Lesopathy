//
//  HeaderLabelTableCell.swift
//  SellFashion
//
//  Created by Sergey Balashov on 21.04.2020.
//  Copyright © 2020 Egor Otmakhov. All rights reserved.
//

import UIKit

class HeaderLabelTableCell: LabelTableCell {
    override func commonInit() {
        super.commonInit()
        label.font = .zeplin34Black
        label.textColor = .gray34
    }
}
