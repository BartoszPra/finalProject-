//
//  CoreDataController.swift
//  ScrimmageFinder App
//
//  Created by The App Experts on 26/06/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import Foundation
import CoreData
import Dispatch
import UIKit

class CoreDataController {

    private init() {}
    
    static let shared = CoreDataController()
        
    // dispatch queues
    let convertQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)
    let saveQueue = DispatchQueue(label: "saveQueue", attributes: .concurrent)
    
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
    func saveContext() {
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
            print(entitiesCount)
        } catch {
            print("error executing fetch request: \(error)")
        }
        return entitiesCount > 0 ? false : true
    }
    
    func prepareImageForSaving(image: UIImage) {
        
        // use date as unique id
        let date: Double = NSDate().timeIntervalSince1970
        // create NSData from UIImage
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        // scale image, I chose the size of the VC because it is easy
        let thumbnail = image.resizeImage(targetSize: CGSize(width: 100, height: 100))
        
        guard let thumbnailData  = thumbnail.jpegData(compressionQuality: 0.7) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        // send to save function
        self.saveImage(imageData: imageData as NSData, thumbnailData: thumbnailData as NSData, date: date)
    }
    
    func saveImage(imageData: NSData, thumbnailData: NSData, date: Double) {
        
        // create new objects in moc
        let moc = persistentContainer.viewContext
        
        guard let fullRes = NSEntityDescription.insertNewObject(forEntityName: "FullRes", into: moc) as? FullRes,
            let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: moc) as? Thumbnail else {
                // handle failed new object in moc
                print("moc error")
                return
        }
        
        //set image data of fullres
        fullRes.imageData = imageData as Data
        
        //set image data of thumbnail
        thumbnail.imageData = thumbnailData as Data
        thumbnail.id = date as Double
        thumbnail.fullRes = fullRes
        
        // save the new objects
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // clear the moc
        moc.refreshAllObjects()
    }
    
    enum ImageType: String {
        case fullSize, thumbnail
        
        var description: String {
            switch self {
            case .fullSize: return "FullRes"
            case .thumbnail: return "Thumbnail"
            }
        }
    }
    
    func removeProfileImage() {
        
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FullRes")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let deleteFetchThumbnail = NSFetchRequest<NSFetchRequestResult>(entityName: "Thumbnail")
        let deleteThumbnailsRequest = NSBatchDeleteRequest(fetchRequest: deleteFetchThumbnail)
        do {
            try context.execute(deleteRequest)
            try context.execute(deleteThumbnailsRequest)
            try context.save()
            print("Profile image deleted")
        } catch {
            print("There was an error")
        }
    }
    
    func loadImage(for userId: String, images: ([FullRes]?) -> Void) {
        
        let moc = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FullRes")
        
        do {
            let results = try moc.fetch(fetchRequest)
            let imageData = results as? [FullRes]
            images(imageData)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return
        }
    }
}
