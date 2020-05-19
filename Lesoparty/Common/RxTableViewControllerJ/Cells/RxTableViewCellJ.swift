//
//  RxTableViewCellJ.swift
//  SellFashion
//
//  Created by Sergey Balashov on 23/07/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit
import SBHelpers

class DisclosureIndicator: UIButton {
    convenience init() {
        self.init(frame: .zero)
        setImage(UIImage(named: "disclosureIndicator")?.withRenderingMode(.alwaysOriginal), for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        sizeToFit()
        isUserInteractionEnabled = false
        tintColor = .white
    }
}

class CheckmarkIcon: UIButton {
    convenience init() {
        self.init(frame: .zero)
        setImage(UIImage(named: "white_check_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        sizeToFit()
        isUserInteractionEnabled = false
        tintColor = .white
    }
}

class RxTableViewCellJ: RxTableViewCell {
    override var accessoryType: UITableViewCell.AccessoryType {
        get { super.accessoryType }
        set {
            if newValue == .disclosureIndicator {
                super.accessoryType = .none
                accessoryView = DisclosureIndicator()
            } else if newValue == .checkmark {
                super.accessoryType = .none
                accessoryView = CheckmarkIcon()
            } else {
                accessoryView = nil
                super.accessoryType = newValue
            }
        }
    }

    override var tintColor: UIColor! {
        didSet {
            if let accessoryView = (accessoryView as? DisclosureIndicator) ?? (accessoryView as? CheckmarkIcon) {
                accessoryView.tintColor = tintColor
            }
        }
    }

    override func commonInit() {
        super.commonInit()
        selectionStyle = .none
        backgroundColor = .clear
    }
}
