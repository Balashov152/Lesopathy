//
//  PaddingLabel.swift
//  freecash
//
//  Created by Sergey on 18.12.17.
//  Copyright © 2017 Михаил. All rights reserved.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 10.0
    var rightInset: CGFloat = 10.0

    open var contentInset: UIEdgeInsets?

    override func drawText(in rect: CGRect) {
        let insets = contentInset ?? UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if let contentInset = contentInset {
            contentSize.height += contentInset.top + contentInset.bottom
            contentSize.width += contentInset.left + contentInset.right
        } else {
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
        }
        return contentSize
    }
}
