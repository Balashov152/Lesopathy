//
//  RxTableViewModel.swift
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

public protocol RxViewModeble: ErrorHandler, ActivityTracker {}

public protocol RxTableViewModeble: RxViewModeble {
    var sections: BehaviorRelay<[TableViewSection]> { get }
}

open class RxTableViewModel: RxViewModel, RxTableViewModeble {
    public typealias Section = AnimatableSectionModel<String, TableSectionItem>
    public var sections = BehaviorRelay<[Section]>(value: [])
}

public protocol RxSaveViewModelble: RxTableViewModel {
    var didTapSaveButton: PublishSubject<Void> { get set }
    var isEnableSaveButton: BehaviorRelay<Bool> { get set }
    var isHideSaveButton: BehaviorRelay<Bool> { get set }
}

extension RxSaveViewModelble {
    var isHideSaveButton: BehaviorRelay<Bool> {
        get { BehaviorRelay<Bool>(value: false) }
        set { print("isHideSaveButton: ", newValue) }
    }
}

open class RxSaveViewModel: RxTableViewModel, RxSaveViewModelble {
    public var didTapSaveButton = PublishSubject<Void>()
    public var isEnableSaveButton = BehaviorRelay<Bool>(value: false)
    public var isHideSaveButton = BehaviorRelay<Bool>(value: false)
}
