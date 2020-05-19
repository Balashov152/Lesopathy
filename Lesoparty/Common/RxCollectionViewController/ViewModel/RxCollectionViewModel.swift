//
//  RxSaveCollectionViewModel.swift
//  SellFashion
//
//  Created by Sergey Balashov on 09.01.2020.
//  Copyright © 2020 Sellfashion. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import SBHelpers

public protocol RxCollectionViewModeble: ErrorHandler, ActivityTracker {
    associatedtype TypeSection: IdentifiableType
    typealias Section = AnimatableSectionModel<TypeSection, CollectionSectionItem>
    var sections: BehaviorRelay<[Section]> { get }
}

open class RxCollectionViewModel: RxViewModel, RxCollectionViewModeble {
    public typealias TypeSection = String
    public var sections = BehaviorRelay<[Section]>(value: [])
}

public protocol RxSaveCollectionViewModelble: RxCollectionViewModel {
    var didTapSaveButton: PublishSubject<Void> { get set }
    var isEnableSaveButton: BehaviorRelay<Bool> { get set }
}

open class RxSaveCollectionViewModel: RxCollectionViewModel, RxSaveCollectionViewModelble {
    public var didTapSaveButton = PublishSubject<Void>()
    public var isEnableSaveButton = BehaviorRelay<Bool>(value: false)
}
