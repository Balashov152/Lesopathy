//
//  NSManagedObjectExtensions.swift
//  baza
//
//  Created by Evgeny Serikov on 25/12/2018.
//  Copyright © 2018 Neuron. All rights reserved.
//

import CoreData
import UIKit

extension NSPredicate {
    convenience init(id: String) {
        self.init(format: "id == %@", id)
    }
}

extension Array where Element: NSManagedObject {
    func array<T: NSManagedObject>() -> [T] { compactMap { $0 as? T } }
}

extension NSManagedObject {
    static func findAll<T: NSManagedObject>(predicate: NSPredicate? = nil,
                                            sortDescriptors: [NSSortDescriptor]? = nil,
                                            context: NSManagedObjectContext) -> [T] {
        guard !CoreDataService.shared.isUpdatingNow else { return [] }
        return find(predicate: predicate, sortDescriptors: sortDescriptors, context: context) as? [T] ?? []
    }

    static func findFirst(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext) -> Self? {
        guard !CoreDataService.shared.isUpdatingNow else { return nil }
        return findFirstJ(predicate: predicate, sortDescriptors: sortDescriptors, context: context)
    }

    static func truncateAll(inContext context: NSManagedObjectContext) {
        let allObjects = findAll(context: context)
        CoreDataService.shared.isUpdatingNow = true
        for item in allObjects {
            context.delete(item)
        }
        CoreDataService.shared.isUpdatingNow = false
    }

    static func find(predicate: NSPredicate? = nil,
                     sortDescriptors: [NSSortDescriptor]? = nil,
                     context: NSManagedObjectContext) -> [NSManagedObject] {
        guard !CoreDataService.shared.isUpdatingNow else { return [] }

        let request: NSFetchRequest<NSManagedObject>
        if let entityName = entity().name {
            request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        } else {
            request = NSFetchRequest<NSManagedObject>()
        }

        request.entity = entity()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            debugPrint(error)
        }
        return []
    }

    // MARK: Private

    private static func addEntity(context: NSManagedObjectContext) -> Self? {
        if let name = entity().name {
            return addEntityJ(entityName: name, context: context)
        }
        return nil
    }

    private static func addEntityJ<T>(entityName: String, context: NSManagedObjectContext) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
    }

    private static func findFirstJ<T>(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext) -> T? {
        return find(predicate: predicate, sortDescriptors: sortDescriptors, context: context).first as? T
    }

    func inContext(context: NSManagedObjectContext) -> Self? {
        return inContextT(context: context)
    }

    private func inContextT<T>(context: NSManagedObjectContext) -> T? {
        do {
            try managedObjectContext?.obtainPermanentIDs(for: [self])
        } catch {
            return nil
        }

        let obj = context.object(with: objectID)

        return obj as? T
    }
}
