//
//  RxTableViewControllerJ.swift
//  SellFashion
//
//  Created by Sergey Balashov on 06.11.2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit
import SBHelpers
import NSObject_Rx
import SnapKit

class RxAnimatedTableViewControllerJ<ViewModel: RxTableViewModeble>: RxTableController<ViewModel> {
    open var animationConfiguration: AnimationConfiguration {
        AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
    }

    lazy var dataSource = StringDataSource.TableView.animated(animationConfiguration: animationConfiguration)

    override func setupBindings() {
        super.setupBindings()
        viewModel.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
}

class RxTableViewControllerJ<ViewModel: RxTableViewModeble>: RxTableController<ViewModel> {
    var dataSource = StringDataSource.TableView.reload()

    override func setupBindings() {
        super.setupBindings()
        viewModel.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
}

class RxTableController<ViewModel: RxTableViewModeble>: RxViewControllerJ<ViewModel> {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }

    override func setupBindings() {
        super.setupBindings()
        tableView.rx.actionModelSelected(TableSectionItem.self)
            .disposed(by: rx.disposeBag)
    }
}
