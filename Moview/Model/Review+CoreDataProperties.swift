//
//  Review+CoreDataProperties.swift
//  
//
//  Created by admin on 13/07/2021.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var genre: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var movieName: String?
    @NSManaged public var rating: String?
    @NSManaged public var releaseYear: String?
    @NSManaged public var review: String?
    @NSManaged public var summary: String?
    @NSManaged public var userName: String?

}
