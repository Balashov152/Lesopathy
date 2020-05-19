//
//  RxViewController.swift
//  SellFashion
//
//  Created by Sergey on 19/07/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

open class RxViewControllerJ<ViewModel: RxViewModeble>: UIViewController {
    public var viewModel: ViewModel!
    public let disposeBag = DisposeBag()
    
    convenience init(viewModel: ViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    open override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    deinit {
        debugPrint("deinit", type(of: self))
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigation()
    }
    
    open func setupBindings() {
        viewModel.error
        .filter { [weak self] _ in self?.viewModel.showErrorAlert ?? false }
        .bind(to: errorAlert).disposed(by: disposeBag)
    }
    
    open func setupNavigation() {}
}
