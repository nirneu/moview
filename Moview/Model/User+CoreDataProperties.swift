//
//  User+CoreDataProperties.swift
//  
//
//  Created by admin on 13/07/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var wasDeleted: Bool

}