//
//  UnsplashItemEntity+CoreDataProperties.swift
//  UnsplashAPIFetch
//
//  Created by Дмитрий Ф on 07/06/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//
//

import Foundation
import CoreData


extension UnsplashItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnsplashItemEntity> {
        return NSFetchRequest<UnsplashItemEntity>(entityName: "UnsplashItemEntity")
    }

    @NSManaged public var alt_description: String?
    @NSManaged public var created_at: String
    @NSManaged public var id: String
    @NSManaged public var image: Data
    @NSManaged public var mainDescription: String?
    @NSManaged public var searchQuery: String
    @NSManaged public var urls: NSObject
    @NSManaged public var user: NSObject
    @NSManaged public var savedDate: Date

}
