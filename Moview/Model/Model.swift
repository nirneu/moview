//
//  Model.swift
//  Moview
//
//  Created by admin on 05/07/2021.
//

import Foundation
import UIKit
import CoreData

class Model {
    
    static let instance = Model()
    
    private init(){}
        
    func getAllReviews(callback:@escaping ([Review])->Void){
        
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
    
    func add(review:Review){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func delete(review:Review){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(review)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func getReview(byId:String)->Review?{
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