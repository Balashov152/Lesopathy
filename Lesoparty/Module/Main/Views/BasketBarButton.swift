//
//  BasketBarButton.swift
//  SellFashion
//
//  Created by Sergey Balashov on 09.01.2020.
//  Copyright © 2020 Sellfashion. All rights reserved.
//

import Foundation
import UIKit

class BasketBarButton: UIButton {
    private lazy var badgeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .zeplin12Regular
        label.backgroundColor = .badgeColor
        label.textAlignment = .center
        label.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        label.clipsToBounds = true
        return label
    }()

    var badgeValue: Int = 0 {
        didSet {
            badgeLabel.textColor = .gray255
            badgeLabel.isHidden = badgeValue == 0
            badgeLabel.text = badgeValue > 99 ? "99+" : "\(badgeValue)"
            badgeLabel.layoutIfNeeded()
            badgeLabel.layer.cornerRadius = badgeLabel.frame.height / 2
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        tintColor = .gray34
        imageView?.contentMode = .scaleAspectFit

        let width = widthAnchor.constraint(equalToConstant: 40)
        width.priority = .defaultHigh
        width.isActive = true

        let height = heightAnchor.constraint(equalToConstant: 40)
        height.priority = .defaultHigh
        height.isActive = true

        setImage(#imageLiteral(resourceName: "bag_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: -8)

        addSubview(badgeLabel)

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.widthAnchor.constraint(greaterThanOrEqualTo: badgeLabel.heightAnchor).isActive = true
        badgeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        badgeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true
    }
}
