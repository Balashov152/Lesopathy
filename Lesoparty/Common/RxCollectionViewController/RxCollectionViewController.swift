//
//  RxCollectionViewController.swift
//  SellFashion
//
//  Created by Sergey Balashov on 13/08/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit
import SBHelpers

class RxAnimatedCollectionViewControllerJ<ViewModel: RxCollectionViewModeble>: RxCollectionViewControllerJ<ViewModel> {
    var animationConfiguration: AnimationConfiguration {
        AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
    }

    lazy var dataSource = DataSource<ViewModel.TypeSection>.CollectionView.animated(animationConfiguration: animationConfiguration)

    override func setupBindings() {
        super.setupBindings()
        viewModel.sections.asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

class RxReloadCollectionViewControllerJ<ViewModel: RxCollectionViewModeble>: RxCollectionViewControllerJ<ViewModel> {
    var dataSource = DataSource<ViewModel.TypeSection>.CollectionView.reload()

    override func setupBindings() {
        super.setupBindings()
        viewModel.sections.asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

class RxCollectionViewControllerJ<ViewModel: RxCollectionViewModeble>: RxCollectionViewController {
    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigation()
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.error
            .filter { [weak self] _ in self?.viewModel.showErrorAlert ?? false }
            .bind(to: errorAlert).disposed(by: disposeBag)

        collectionView.rx.actionModelSelected(CollectionSectionItem.self)
            .disposed(by: disposeBag)
    }
}

class RxCollectionViewController: UICollectionViewController {
    let disposeBag = DisposeBag()

    deinit {
        debugPrint("deinit", type(of: self))
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        modalPresentationStyle = .overFullScreen
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .overFullScreen
    }

    override func loadView() {
        super.loadView()
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.register(cell: RxCollectionViewCellJ.self)

        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }

    open func setupBindings() {}
    open func setupNavigation() {}
}
