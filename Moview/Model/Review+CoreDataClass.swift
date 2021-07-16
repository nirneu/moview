//
//  Review+CoreDataClass.swift
//  
//
//  Created by admin on 15/07/2021.
//
//

import Foundation
import CoreData
import UIKit
import Firebase

@objc(Review)
public class Review: NSManagedObject {
    static func createReview(movieName: String, releaseYear: String, genre: String, imageUrl: String, rating: String, review: String, userName:String , lastUpdated: Int64)-> Review {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let currReview = Review(context: context)
        currReview.movieName = movieName
        currReview.releaseYear = releaseYear
        currReview.genre = genre
        currReview.review = review
        currReview.imageUrl = imageUrl
        currReview.rating = rating
        currReview.userName = userName
        currReview.lastUpdated = lastUpdated
        currReview.wasDeleted = false
        
        return currReview
    }
    
    static func create(json:[String:Any])->Review? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let review = Review(context: context)
//        review.id = json["id"] as? String
        review.movieName = json["movieName"] as? String
        review.releaseYear = json["releaseYear"] as? String
        review.genre = json["genre"] as? String
        review.review = json["review"] as? String
        review.rating = json["rating"] as? String
        review.userName = json["userName"] as? String
        review.imageUrl = json["imageUrl"] as? String
        review.lastUpdated = 0
        
        if let timestamp = json["lastUpdated"] as? Timestamp {
            review.lastUpdated = Int64(timestamp.seconds)
        }
        
        if let wasDeleted = json["wasDeleted"] as? Bool {
            review.wasDeleted = wasDeleted
        }
        
        return review
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
//        json["id"] = id!
        json["movieName"] = movieName!
        json["releaseYear"] = releaseYear!
        json["genre"] = genre!
        json["review"] = review!
        json["rating"] = rating!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["wasDeleted"] = wasDeleted
        
        return json
    }
}

extension Review {
    static func getAll(callback:@escaping ([Review])->Void){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        DispatchQueue.global().async {
            // second thread code
            var data = [Review]()
            do {
                data = try context.fetch(request)
            } catch {
            }
            
            DispatchQueue.main.async {
                // code to execute on main thread
                callback(data)
            }
        }
    }
    
    func save(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func delete(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    static func getReview(byId:String)->Review?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.predicate = NSPredicate(format: "id == \(byId)")
        do {
            let reviews = try context.fetch(request)
            if reviews.count > 0 {
                return reviews[0]
            }
        } catch {
            
        }
        return nil
    }
}
