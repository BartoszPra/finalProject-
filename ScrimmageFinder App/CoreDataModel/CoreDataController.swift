//
//  CoreDataController.swift
//  ScrimmageFinder App
//
//  Created by The App Experts on 26/06/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {

    private init() {}
    
    static let shared = CoreDataController()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ScrimmageFinder_App")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //function to check if Entity exist in the core data
    func entityExists(scrimmage: Scrimmage) -> Bool {
        //fetching all the entities using predicate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScrimmageSaved")
        let predicate = NSPredicate(format: "name =" + scrimmage.name)
        fetchRequest.predicate = predicate
        var entitiesCount = 0
        do {
            entitiesCount = try self.mainContext.count(for: fetchRequest)
            print (entitiesCount)
        } catch {
            print("error executing fetch request: \(error)")
        }
        return entitiesCount > 0 ? false : true
    }
}
