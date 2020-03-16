//
//  Thumbnail+CoreDataProperties.swift
//  
//
//  Created by Bartosz Prazmo on 03/12/2019.
//
//

import Foundation
import CoreData

extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var id: Double
    @NSManaged public var imageData: NSData?
    @NSManaged public var fullRes: FullRes?

}
