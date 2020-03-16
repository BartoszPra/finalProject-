//
//  FullRes+CoreDataProperties.swift
//  
//
//  Created by Bartosz Prazmo on 03/12/2019.
//
//

import Foundation
import CoreData

extension FullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullRes> {
        return NSFetchRequest<FullRes>(entityName: "FullRes")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var thumbnail: Thumbnail?

}
