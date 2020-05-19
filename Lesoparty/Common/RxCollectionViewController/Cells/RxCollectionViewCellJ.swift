//
//  RxCollectionViewCellJ.swift
//  SellFashion
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Egor Otmakhov. All rights reserved.
//

import Foundation
import SBHelpers

class RxCollectionViewCellJ: RxCollectionViewCell, RxViewModable {
    override func commonInit() {
        super.commonInit()
        backgroundColor = .clear
    }

    open func setupWith(viewModel _: RowViewModel) {}
}
