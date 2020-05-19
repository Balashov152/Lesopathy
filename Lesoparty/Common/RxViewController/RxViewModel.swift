//
//  RxViewModel.swift
//  SellFashion
//
//  Created by Sergey Balashov on 23/07/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit
import SBHelpers

open class RxViewModel: NSObject, ActivityTracker, ErrorHandler {
    public let disposeBag = DisposeBag()
    public let activityIndicator = ActivityIndicator()

    public let error = PublishSubject<Error>()
    public var showErrorAlert = true

    open func commonInit() {
        setupBindings()
    }

    open func setupBindings() {}

    public override init() {
        super.init()
        debugPrint("init", type(of: self))
        commonInit()
    }

    deinit {
        debugPrint("deinit", type(of: self))
    }
}
