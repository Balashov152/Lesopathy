//
//  WordsViewModel.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation
import CoreData

class WordsViewModel: RxTableViewModel {
    lazy var fetchController: NSFetchedResultsController<Word> = {
        let reqeust = NSFetchRequest<Word>(entityName: "Word")
        reqeust.sortDescriptors = [NSSortDescriptor(key: "create", ascending: false)]
        let controller = NSFetchedResultsController<Word>(fetchRequest: reqeust,
                                                          managedObjectContext: CoreDataService.shared.context,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    override func setupBindings() {
        super.setupBindings()
        fetchData()
        sections.accept(setupSections())
    }
    
    func setupSections() -> [Section] {
        let words: [Word] = fetchController.fetchedObjects ?? []
        let items = words.map { word -> LabelViewModel in
            let item = LabelViewModel(identity: word.id?.uuidString, cellType: LabelTableCell.self)
            item.text.accept(word.original.orEmpty + " - " + word.translate.orEmpty)
            
            item.action.subscribe(onNext: {
                PushManager.shared.sendLocalPush(PushMessage(title: word.original.orEmpty,
                                                             subtitle: word.translate.orEmpty))
            }).disposed(by: item.rx.disposeBag)
            
            return item
        }
        
        return [Section(model: "Section", items: items)]
    }
    
    func fetchData() {
        do {
            try fetchController.performFetch()
        } catch {
            self.error.onNext(error)
        }
    }
}

extension WordsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sections.accept(setupSections())
    }
}