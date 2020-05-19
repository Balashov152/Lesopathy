//
//  DatePickerTableCell.swift
//  SellFashion
//
//  Created by Sergey Balashov on 11.11.2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import SBHelpers

class DatePickerTableCellViewModel: TableSectionItem {
    var selectedDate = BehaviorRelay<Date?>(value: nil)
}

class DatePickerTableCell: RxTableViewCellJ, RxViewModable {
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
//        let calendar = Calendar.current
//        datePicker.maximumDate = calendar.date(byAdding: .year, value: -14, to: Date())
//        datePicker.minimumDate = calendar.date(byAdding: .year, value: -80, to: Date())
        datePicker.datePickerMode = .time
        return datePicker
    }()

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    func setupWith(viewModel: RowViewModel) {
        if let viewModel = viewModel as? DatePickerTableCellViewModel {
            viewModel.selectedDate.unwrap()
                .bind(to: datePicker.rx.date)
                .disposed(by: disposeBag)

            datePicker.rx.date
                .bind(to: viewModel.selectedDate)
                .disposed(by: disposeBag)
        }
    }
}
