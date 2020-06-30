//
//  WordsViewController.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WordsViewController<ViewModel: WordsViewModel>: RxTableViewControllerJ<ViewModel> {
    
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
    
    override func loadView() {
        super.loadView()
        title = "Words"
        navigationItem.rightBarButtonItem = addButton
        tableView.register(cell: WordTableCell.self)
    }
    
    override func setupBindings() {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath  in
          return true
        }
        
        super.setupBindings()
        
        tableView.rx.itemDeleted
            .bind(to: viewModel.deleteItem).disposed(by: disposeBag)
    }
    
    @IBAction func addAction(_: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add word", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "word"
            textField.keyboardType = .asciiCapable
            textField.autocorrectionType = .default
            textField.tag = 1
        }

        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {[weak self]  _ in
            if let word = alert.textFields?.first(where: { $0.tag == 1 })?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                word.isCorrectWord {
                YandexTranslateService().translateAndSaveWord(text: word, completion: { [weak self] in
                    self?.viewModel.fetchData()
                })
            } else {
                self?.showErrorAlert(errorMessage: "Not correct word")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
}
