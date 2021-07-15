//
//  User+CoreDataClass.swift
//  
//
//  Created by admin on 13/07/2021.
//
//

import Foundation
import CoreData
import UIKit
import Firebase

@objc(User)
public class User: NSManagedObject {
    static func create(id: String, fullName: String, imageUrl: String, lastUpdated: Int64) -> User {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = User(context: context)
        user.id = id
        user.fullName = fullName
        user.imageUrl = imageUrl
        user.lastUpdated = lastUpdated
        user.wasDeleted = false
        return user
    }
    
    static func create(json:[String:Any])->User? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = User(context: context)
        user.id = json["id"] as? String
        user.fullName = json["fullName"] as? String
        user.imageUrl = json["imageUrl"] as? String
        user.lastUpdated = 0
        
        if let timestamp = json["lastUpdated"] as? Timestamp {
            user.lastUpdated = Int64(timestamp.seconds)
        }
        
        if let wasDeleted = json["wasDeleted"] as? Bool {
            user.wasDeleted = wasDeleted
        }
        
        return user
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
        json["id"] = id!
        json["fullName"] = fullName!
        json["imageUrl"] = imageUrl!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["wasDeleted"] = wasDeleted
        
        return json
    }
}

extension User {
    func save() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSOverwriteMergePolicy
        do{
            try context.save()
        }
        catch {}
    }
}
