//
//  CoreDataService.swift
//  SellFashion
//
//  Created by Sergey Balashov on 15/07/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import CoreData
import Foundation
import RxSwift

extension NSManagedObjectContext {
    static var main: NSManagedObjectContext { CoreDataService.shared.context }
}

class CoreDataService {
    static let shared = CoreDataService()
    static let version = 1
    var isUpdatingNow = false // TODO: FIX

    private init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: .NSManagedObjectContextObjectsDidChange, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: .NSManagedObjectContextWillSave, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: .NSManagedObjectContextDidSave, object: context)
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func deleteCache() {
        Word.truncateAll(inContext: context)
        saveContext()
    }

    @discardableResult
    func createOrUpdate<Object: NSManagedObject>(id: String, type _: Object.Type = Object.self,
                                                 context: NSManagedObjectContext,
                                                 fillObject: (_ object: Object) -> Void) -> Object {
        return createOrUpdate(predicate: NSPredicate(id: id), context: context, fillObject: fillObject)
    }

    @discardableResult
    func createOrUpdate<Object: NSManagedObject>(predicate: NSPredicate,
                                                 context: NSManagedObjectContext,
                                                 fillObject: (_ object: Object) -> Void) -> Object {
        let object: Object

        let cacheObject: Object?
        let name = Object.entity().name ?? ""
        let request = NSFetchRequest<Object>(entityName: name)
        request.predicate = predicate

        do {
            let result = try context.fetch(request)
            cacheObject = result.first
        } catch {
            cacheObject = nil
            debugPrint("CORE DATA ERROR: ", error)
        }

        if let cacheObject = cacheObject {
            object = cacheObject
        } else {
            let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
            object = Object(entity: entity, insertInto: context)
        }

        fillObject(object)
        return object
    }

    // MARK: - Core Data stack

    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("--- INSERTS ---")
            print(inserts)
            print("+++++++++++++++")
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("--- UPDATES ---")
            updates.forEach { print($0) }
            print("+++++++++++++++")
        }

        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            print("--- DELETES ---")
            print(deletes)
            print("+++++++++++++++")
        }
    }

    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        guard let mom = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Could not load model")
        }

        let container = NSPersistentContainer(name: "Lesoparty", managedObjectModel: mom)
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("context did save")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        debugPrint(#function)
        debugPrintCount()
    }

    func debugPrintCount() {
        DispatchQueue.main.async {
            print(#function)
            print("Word", (try? self.context.count(for: Word.fetchRequest())) ?? 0)
        }
    }
}
